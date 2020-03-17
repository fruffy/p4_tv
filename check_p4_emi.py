import argparse
import logging
import time
import os
import sys
import itertools
from pathlib import Path
from dataclasses import dataclass

import z3
import p4z3.util as util
import check_p4_pair as z3check

log = logging.getLogger(__name__)

FILE_DIR = Path(__file__).parent.resolve()
P4Z3_BIN = FILE_DIR.joinpath("p4c/build/p4toz3")
P4RANDOM_BIN = FILE_DIR.joinpath("p4c/build/p4bludgeon")
OUT_DIR = FILE_DIR.joinpath("validated")
P4C_DIR = FILE_DIR.joinpath("p4c")
TOFINO_DIR = FILE_DIR.joinpath("tofino/bf_src")

NUM_RETRIES = 10
USE_TOFINO = False


@dataclass
class P4Struct:
    name: str
    values: list


def generate_random_prog(p4c_bin, p4_file):
    p4_cmd = f"{p4c_bin} "
    p4_cmd += f"{p4_file} "
    if USE_TOFINO:
        p4_cmd += f"1 "
    log.info("Generating random p4 code with command %s ", p4_cmd)
    return util.exec_process(p4_cmd)


def run_p4_to_py(p4_file, py_file, option_str=""):
    cmd = f"{P4Z3_BIN} "
    cmd += f"{p4_file} "
    cmd += f"--output {py_file} "
    cmd += option_str
    if USE_TOFINO:
        include_dir = TOFINO_DIR.joinpath(f"install/share/p4c/p4include/ ")
        cmd += f"-I {include_dir}"
    log.info("Converting p4 to z3 python with command %s ", cmd)
    return util.exec_process(cmd)


def fill_values(z3_input):
    input_values = []
    for val in z3_input.children():
        if isinstance(val, z3.DatatypeRef):
            val_name = val.sort().name()
            val_children = fill_values(val)
            complex_val = P4Struct(val_name, val_children)
            input_values.append(complex_val)
        elif isinstance(val, z3.BitVecNumRef):
            bitvec_val = val.as_long()
            bitvec_hex_width = (val.size()) // 4
            hex_str = f"{bitvec_val:0{bitvec_hex_width}X}"
            input_values.append(hex_str)
        else:
            raise RuntimeError(f"Type {type(val)} not supported!")
    return input_values


def get_branch_conditions(z3_formula):
    conditions = []
    table_keys = []
    if z3.is_app_of(z3_formula, z3.Z3_OP_ITE):
        # the first child is usually the condition
        cond = z3_formula.children()[0]
        cond_vars = z3.z3util.get_vars(cond)
        is_member = "ingress_0" in [str(x) for x in cond_vars]
        is_table_key = "table_key" in "".join([str(x) for x in cond_vars])
        if is_table_key:
            table_keys.append(cond)
        elif is_member:
            conditions.append(cond)
    for child in z3_formula.children():
        sub_conds, sub_table_keys = get_branch_conditions(child)
        conditions.extend(sub_conds)
        table_keys.extend(sub_table_keys)
    return conditions, table_keys


def convert_to_stf(input_values, input_name, append_values=False):
    stf_str = ""
    for val in input_values:
        if isinstance(val, P4Struct):
            if val.name == input_name:
                stf_str += convert_to_stf(
                    val.values, input_name, True)
            else:
                stf_str += convert_to_stf(
                    val.values, input_name, append_values)
        elif isinstance(val, str):
            if append_values:
                stf_str += val
        else:
            raise RuntimeError(f"Type {type(val)} not supported!")
    return stf_str


def insert_spaces(text, dist):
    return " ".join(text[i:i + dist] for i in range(0, len(text), dist))


def get_stf_str(z3_model, z3_const):
    z3_input_header = z3_model[z3_model[0]]
    log.debug("Input header: %s", z3_input_header)
    input_values = fill_values(z3_input_header)
    input_pkt_str = convert_to_stf(input_values, "Headers")
    z3_output_header = z3_model[z3_const]
    log.debug("Output header: %s", z3_output_header)
    output_values = fill_values(z3_output_header)
    output_pkt_str = convert_to_stf(output_values, "Headers")
    stf_str = "packet 0 "
    stf_str += insert_spaces(input_pkt_str, 2)
    stf_str += "\nexpect 0 "
    stf_str += insert_spaces(output_pkt_str, 2)
    return stf_str


def get_semantics(out_dir, p4_input):
    p4_input = Path(p4_input)
    py_file = Path(f"{out_dir}/{p4_input.stem}.py")
    fail_dir = out_dir.joinpath("failed")

    result = run_p4_to_py(p4_input, py_file)
    if result.returncode != util.EXIT_SUCCESS:
        log.error("Failed to translate P4 to Python.")
        util.check_dir(fail_dir)
        with open(f"{fail_dir}/error.txt", 'w+') as err_file:
            err_file.write(result.stderr.decode("utf-8"))
        util.copy_file([p4_input, py_file], fail_dir)
        return None, result.returncode
    z3_prog, result = z3check.get_z3_formulization(py_file, fail_dir)
    if result != util.EXIT_SUCCESS:
        return None, result
    return z3_prog, util.EXIT_SUCCESS


def run_bmv2_test(out_dir, p4_input):
    cmd = "python "
    cmd += f"{P4C_DIR}/backends/bmv2/run-bmv2-test.py "
    cmd += f"{P4C_DIR} -v "
    cmd += f"-bd {P4C_DIR}/build "
    cmd += f"{out_dir}/{p4_input.name} "
    return util.exec_process(cmd)


# def report_error(result, text):
#     log.error(text)
#     log.error("*" * 60)
#     log.error(result.stdout.decode("utf-8"))
#     log.error("*" * 60)
#     return result


def cleanup(procs):
    sighup = 1
    sigkill = 9
    for proc in procs:
        os.killpg(os.getpgid(proc.pid), sighup)
        os.killpg(os.getpgid(proc.pid), sigkill)


def run_tofino_test(out_dir, p4_input, stf_file_name):
    # we need to change the working directory
    # tofino scripts make some assumptions where to dump files
    prog_name = p4_input.stem
    # we need to create a specific test dir in which we can run tests
    test_dir = out_dir.joinpath("test_dir")
    util.check_dir(test_dir)
    util.copy_file(stf_file_name, test_dir)
    template_name = test_dir.joinpath(f"{prog_name}.py")
    # use a test template that runs stf tests
    util.copy_file(f"{FILE_DIR}/tofino_test_template.py", template_name)

    # initialize the target install
    config_cmd = f"{TOFINO_DIR}/pkgsrc/p4-build/configure "
    config_cmd += f"--with-tofino --with-p4c=bf-p4c "
    config_cmd += f"--prefix={TOFINO_DIR}/install "
    config_cmd += f"--bindir={TOFINO_DIR}/install/bin "
    config_cmd += f"P4_NAME={prog_name} "
    config_cmd += f"P4_PATH={p4_input.resolve()} "
    config_cmd += f"P4_VERSION=p4-16 "
    config_cmd += f"P4_ARCHITECTURE=tna "
    result = util.exec_process(config_cmd, cwd=out_dir)
    if result.returncode != util.EXIT_SUCCESS:
        return result
    # create the target
    make_cmd = f"make -C {out_dir} "
    result = util.exec_process(make_cmd)
    if result.returncode != util.EXIT_SUCCESS:
        return result
    # install the target in the tofino folder
    make_cmd = f"make install -C {out_dir} "
    result = util.exec_process(make_cmd)
    if result.returncode != util.EXIT_SUCCESS:
        return result
    # start the target in the background
    model_cmd = f"{TOFINO_DIR}/run_tofino_model.sh "
    model_cmd += f"-p {prog_name} "
    model_proc = util.start_process(
        model_cmd, preexec_fn=os.setsid, cwd=out_dir)
    # start the binary for the target in the background
    switch_cmd = f"{TOFINO_DIR}/run_switchd.sh "
    switch_cmd += f"--arch tofino "
    switch_cmd += f"-p {prog_name} "
    switch_proc = util.start_process(
        switch_cmd, preexec_fn=os.setsid, cwd=out_dir)
    # wait for a bit
    time.sleep(2)
    # finally we can run the test
    test_cmd = f"{TOFINO_DIR}/run_p4_tests.sh "
    test_cmd += f"-t {test_dir} "
    os_env = os.environ.copy()
    os_env["PYTHONPATH"] = f"${{PYTHONPATH}}:{FILE_DIR}"
    result = util.exec_process(test_cmd, env=os_env, cwd=out_dir)
    cleanup([model_proc, switch_proc])
    return result


def run_stf_test(out_dir, p4_input, stf_str):
    log.info("Running stf test on file %s", p4_input)
    p4_input = Path(p4_input)
    fail_dir = out_dir.joinpath("failed")
    stf_file_name = out_dir.joinpath(f"{p4_input.stem}.stf")
    with open(stf_file_name, 'w+') as stf_file:
        stf_file.write(stf_str)
    if USE_TOFINO:
        result = run_tofino_test(out_dir, p4_input, stf_file_name)
    else:
        result = run_bmv2_test(out_dir, p4_input)
    if result.returncode != util.EXIT_SUCCESS:
        log.error("Failed to validate %s with a stf test:", p4_input.name)
        log.error("*" * 60)
        log.error(result.stdout.decode("utf-8"))
        log.error("*" * 60)
        log.error(result.stderr.decode("utf-8"))
        log.error("*" * 60)
        util.check_dir(fail_dir)
        with open(f"{fail_dir}/{p4_input.stem}_error.txt", 'w+') as err_file:
            err_file.write(result.stdout.decode("utf-8"))
            err_file.write(result.stderr.decode("utf-8"))
    else:
        log.info("Validation of %s with an stf test succeeded.", p4_input.name)
    return result.returncode


def check_with_stf(out_dir, file_1, file_2, model, output_const):
    # both the input and the output variable are then used to generate
    # a stf file with an input and expected output packet on port 0
    log.info("Generating stf file...")
    stf_str = get_stf_str(model, output_const)
    result = run_stf_test(out_dir, file_1, stf_str)
    if result != util.EXIT_SUCCESS:
        return result
    if isinstance(file_2, list):
        for sub_file in file_2:
            result = run_stf_test(out_dir, sub_file, stf_str)
            if result != util.EXIT_SUCCESS:
                return result
        return util.EXIT_SUCCESS
    else:
        return run_stf_test(out_dir, file_2, stf_str)


def random_prune(out_dir, p4_input, idx):

    p4_input = Path(p4_input)
    py_file = Path(f"{out_dir}/{p4_input.stem}_{idx}.py")
    new_p4_file = Path(f"{out_dir}/{p4_input.stem}_{idx}.py.p4")
    fail_dir = out_dir.joinpath("failed")

    result = run_p4_to_py(p4_input, py_file, option_str="--prune --emit_p4 ")
    if result.returncode != util.EXIT_SUCCESS:
        log.error("Failed to translate pruned P4 to Python.")
        log.error("Compiler crashed!")
        util.check_dir(fail_dir)
        with open(f"{fail_dir}/error.txt", 'w+') as err_file:
            err_file.write(result.stderr.decode("utf-8"))
        util.copy_file([p4_input, py_file], fail_dir)
        return result.returncode
    z3_prog, result = z3check.get_z3_formulization(py_file, fail_dir)
    if result != util.EXIT_SUCCESS:
        return None, None, result
    return new_p4_file, z3_prog, util.EXIT_SUCCESS


def enter_retry_loop(out_dir, p4_input, s, output_const, num_retries):
    log.info("Cannot find an input that leads to equivalence!")
    log.info("Retrying %s times...", num_retries)
    iters = 0
    while iters < num_retries:
        log.info("Attempt Number %s...", iters)
        new_p4, z3_prog, result = random_prune(out_dir, p4_input, iters)
        if result != util.EXIT_SUCCESS:
            return result
        second_formula = z3_prog["ig"]
        s.push()
        # the output of the main formula should be the same as the sub formula
        s.add(output_const == second_formula)
        ret = s.check()
        if ret == z3.sat:
            log.info("Found a solution!")
            # get the model
            m = s.model()
            result = check_with_stf(out_dir, p4_input, new_p4, m, output_const)
            if result != util.EXIT_SUCCESS:
                return result
            break
        s.pop()
        iters += 1
    else:
        log.warning("Exceeded number of retries without success. Exiting.")


def perform_emi_test(out_dir, p4_input, num_subsets, p4_subsets, num_retries):
    if not p4_input:
        out_dir = Path(out_dir).joinpath("rnd_test")
        util.check_dir(out_dir)
        p4_input = out_dir.joinpath("rnd_test.p4")
        # generate a random program from scratch
        generate_random_prog(P4RANDOM_BIN, p4_input)
    else:
        p4_input = Path(p4_input)
        out_dir = Path(out_dir)
        if out_dir == OUT_DIR:
            out_dir = out_dir.joinpath(p4_input.stem)
        util.check_dir(out_dir)
        util.copy_file(p4_input, out_dir)

    z3_subsets = []

    # get the semantic representation of the original program
    z3_main_prog, result = get_semantics(out_dir, p4_input)
    if result != util.EXIT_SUCCESS:
        return result

    # if there is a list of subsets provided get their semantic representation
    for input_prog in p4_subsets:
        z3_prog, result = get_semantics(out_dir, input_prog)
        if result != util.EXIT_SUCCESS:
            return result
        z3_subsets.append(z3_prog)
        util.copy_file(input_prog, out_dir)

    # we can also generate new randomly pruned versions from scratch
    # generate 'num_subsets' new sub programs
    for idx in range(num_subsets):
        new_p4_file, z3_prog, result = random_prune(out_dir, p4_input, idx)
        if result != util.EXIT_SUCCESS:
            return result
        z3_subsets.append(z3_prog)
        p4_subsets.append(new_p4_file)

    # now we actually verify that we can find an input where all these programs
    # are the same. We also have to define a output variable to force the same
    # output conditions
    s = z3.Solver()
    # we currently ignore all other pipelines and focus on the ingress pipeline
    if USE_TOFINO:
        main_formula = z3_main_prog["Pipeline_ingress"]
    else:
        main_formula = z3_main_prog["ig"]
    # this util might come in handy later.
    # z3.z3util.get_vars(main_formula)
    conditions, table_keys = get_branch_conditions(main_formula)
    permuts = [[f(var) for var, f in zip(conditions, x)]
               for x in itertools.product([z3.Not, lambda x: x], repeat=len(conditions))]
    output_const = z3.Const("output", main_formula.sort())
    # bind the output constant to the output of the main program
    s.add(main_formula == output_const)
    # create a context for all the subsets
    s.push()
    for z3_subset_prog in z3_subsets:
        second_formula = z3_subset_prog["ig"]
        # the output of the main formula should be the same as the sub formula
        s.add(second_formula == output_const)
    for permut in permuts:
        s.push()
        s.add(permut)
        for key in table_keys:
            s.add(z3.Not(key))
        ret = s.check()
        if ret == z3.sat:
            log.info("Found a solution!")
            # get the model
            m = s.model()
            result = check_with_stf(
                out_dir, p4_input, p4_subsets, m, output_const)
            if result != util.EXIT_SUCCESS:
                return result
        # else:
        #     log.warning(
        #         "Not able to find an input that produces equivalent output!")
        #     if args.retry:
        #         # remove the context and start fresh
        #         s.pop()
        #         result = enter_retry_loop(
        #             out_dir, p4_input, s, output_const, num_retries)
        #     else:
        #         log.warning(
        #             "Retrying is disabled, enable random subset testing "
        #             "with the --retry/-r flag.")
        s.pop()
        # return result
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--p4_input", dest="p4_input", default=None,
                        type=lambda x: util.is_valid_file(parser, x),
                        help="The main reference p4 file.")
    parser.add_argument("--num_subsets", "-n", dest="num_subsets",
                        type=int, default=0,
                        help="The number of subset programs to generate.")
    parser.add_argument("--subsets", "-s", dest="subsets", type=str,
                        nargs='+', default=[],
                        help="The ordered list of programs to compare.")
    parser.add_argument("--retry", "-r", dest="retry", action='store_true',
                        help="Retry with random mutation to find an equivalence solution.")
    parser.add_argument("--tofino", "-t", dest="use_tofino",
                        action='store_true',
                        help="Use the Tofino compiler instead of P4C.")
    parser.add_argument("--num_retries", dest="num_retries",
                        default=NUM_RETRIES, type=int,
                        help="How many times to retry before giving up.")
    parser.add_argument("-o", "--out_dir", dest="out_dir", default=OUT_DIR,
                        help="The output folder where all passes are dumped.")
    parser.add_argument("-l", "--log_file", dest="log_file", default="emi.log",
                        help="Specifies name of the log file.")
    # Parse options and process argv
    args = parser.parse_args()

    # configure logging
    logging.basicConfig(filename=args.log_file,
                        format="%(levelname)s:%(message)s",
                        level=logging.INFO,
                        filemode='w')
    stderr_log = logging.StreamHandler()
    stderr_log.setFormatter(logging.Formatter("%(levelname)s:%(message)s"))
    logging.getLogger().addHandler(stderr_log)
    USE_TOFINO = args.use_tofino
    result = perform_emi_test(args.out_dir, args.p4_input, args.num_subsets,
                              args.subsets, args.num_retries)
    sys.exit(result)
