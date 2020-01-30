import copy
from collections import OrderedDict
import z3

from p4z3.base import log
from p4z3.base import P4ComplexType, P4Statement, P4Z3Class, P4Context


def z3_implies(p4_state, cond, then_expr):
    log.debug("Evaluating no_match...")
    p4z3_expr = p4_state.pop_next_expr()
    no_match = p4z3_expr.eval(p4_state)
    return z3.If(cond, then_expr, no_match)


class P4Instance():
    def __new__(cls, z3_reg, method_name, *args, **kwargs):
        # global instances typically do not have any state so pass None here
        return z3_reg._globals[method_name](None, *args, **kwargs)


class P4Package():

    def __init__(self, z3_reg, name, *args, **kwargs):
        self.pipes = OrderedDict()
        self.name = name
        self.z3_reg = z3_reg
        for arg in args:
            is_ref = arg[0]
            param_name = arg[1]
            param_sort = arg[2]
            self.pipes[param_name] = None

    def __call__(self, p4_state, *args, **kwargs):
        pipe_list = list(self.pipes.keys())
        merged_args = {}
        for idx, arg in enumerate(args):
            name = pipe_list[idx]
            merged_args[name] = arg
        for name, arg in kwargs.items():
            merged_args[name] = arg
        for name, arg in merged_args.items():
            # only add valid values
            if arg in self.z3_reg._globals:
                self.pipes[name] = self.z3_reg._globals[arg]
        return self


class P4Declaration(P4Statement):
    # the difference between a P4Declaration and a P4Assignment is that
    # we resolve the variable in the P4Assignment
    # in the declaration we assign variables as is.
    # they are resolved at runtime by other classes
    def __init__(self, lval, rval):
        self.lval = lval
        self.rval = rval

    def eval(self, p4_state):
        # this will only resolve expressions no other classes
        rval = p4_state.resolve_expr(self.rval)
        p4_state.set_or_add_var(self.lval, rval)
        p4z3_expr = p4_state.pop_next_expr()
        return p4z3_expr.eval(p4_state)


class AssignmentStatement(P4Statement):
    # AssignmentStatements are essentially just a wrapper class for the
    # set_or_add_var ḿethod of the p4 state.
    # All the important logic is handled there.

    def __init__(self, lval, rval):
        self.lval = lval
        self.rval = rval

    def eval(self, p4_state):
        log.debug("Assigning %s to %s ", self.rval, self.lval)
        rval_expr = p4_state.resolve_expr(self.rval)
        # in assignments all complex types values are copied
        if isinstance(rval_expr, P4ComplexType):
            rval_expr = copy.copy(rval_expr)
        p4_state.set_or_add_var(self.lval, rval_expr)

        p4z3_expr = p4_state.pop_next_expr()
        return p4z3_expr.eval(p4_state)


class MethodCallStmt(P4Statement):

    def __init__(self, method_expr):
        self.method_expr = method_expr

    def eval(self, p4_state):
        expr = self.method_expr.eval(p4_state)
        if callable(expr):
            args = self.method_expr.args
            kwargs = self.method_expr.kwargs
            expr = expr(p4_state, *args, **kwargs)
        if p4_state.expr_chain:
            p4z3_expr = p4_state.pop_next_expr()
            return p4z3_expr.eval(p4_state)
        else:
            return expr


class BlockStatement(P4Statement):

    def __init__(self):
        self.exprs = []

    def preprend(self, expr):
        self.exprs.insert(0, expr)

    def add(self, expr):
        self.exprs.append(expr)

    def eval(self, p4_state):
        p4_state.insert_exprs(self.exprs)
        p4z3_expr = p4_state.pop_next_expr()
        return p4z3_expr.eval(p4_state)


class IfStatement(P4Statement):

    def __init__(self):
        self.cond = None
        self.then_block = None
        self.else_block = None

    def add_condition(self, cond):
        self.cond = cond

    def add_then_stmt(self, stmt):
        self.then_block = stmt

    def add_else_stmt(self, stmt):
        self.else_block = stmt

    def eval(self, p4_state):
        if self.cond is None:
            raise RuntimeError("Missing condition!")
        cond = p4_state.resolve_expr(self.cond)
        # conditional branching requires a copy of the state for each branch
        # in some sense this copy acts as a phi function
        then_expr = self.then_block.eval(copy.copy(p4_state))
        if self.else_block:
            else_expr = self.else_block.eval(p4_state)
            return z3.If(cond, then_expr, else_expr)
        else:
            return z3_implies(p4_state, cond, then_expr)


class SwitchHit(P4Z3Class):
    def __init__(self, table, cases, default_case):
        self.table = table
        self.default_case = default_case
        self.cases = cases

    def eval_cases(self, p4_state, cases):
        p4_state_cpy = copy.copy(p4_state)
        expr = self.default_case.eval(p4_state)
        for case in reversed(cases.values()):
            case_expr = case["case_block"].eval(copy.copy(p4_state_cpy))
            expr = z3.If(case["match"], case_expr, expr)
        return expr

    def eval_switch_matches(self, table):
        for case_name, case in self.cases.items():
            match_var = table.tbl_action
            action = table.actions[case_name][0]
            self.cases[case_name]["match"] = (match_var == action)

    def eval(self, p4_state):
        self.eval_switch_matches(self.table)
        switch_hit = self.eval_cases(p4_state, self.cases)
        return switch_hit


class SwitchStatement(P4Statement):
    # TODO: Fix fall through for switch statement
    def __init__(self, table_str):
        self.table_str = table_str
        self.default_case = BlockStatement()
        self.cases = OrderedDict()

    def add_case(self, action_str):
        # skip default statements, they are handled separately
        if action_str == "default":
            return
        case = {}
        case["case_block"] = BlockStatement()
        self.cases[action_str] = case

    def add_stmt_to_case(self, action_str, case_stmt):
        if action_str == "default":
            self.default_case.add(case_stmt)
        else:
            case_block = self.cases[action_str]["case_block"]
            case_block.add(case_stmt)

    def eval(self, p4_state):
        table = p4_state.resolve_expr(self.table_str)
        # instantiate the hit expression
        switch_hit = SwitchHit(table, self.cases, self.default_case)
        p4_state.insert_exprs([table, switch_hit])
        p4z3_expr = p4_state.pop_next_expr()
        return p4z3_expr.eval(p4_state)


class P4Noop(P4Statement):

    def eval(self, p4_state):
        p4z3_expr = p4_state.pop_next_expr()
        return p4z3_expr.eval(p4_state)


class P4Return(P4Statement):
    def __init__(self, expr=None):
        self.expr = expr

    def eval(self, p4_state):

        # resolve the expr before restoring the state
        if self.expr is None:
            expr = None
        else:
            expr = p4_state.resolve_expr(self.expr)

        chain_copy = p4_state.copy_expr_chain()
        # remove all expressions until we hit the end (typically a context)
        for p4z3_expr in chain_copy:
            p4_state.expr_chain.popleft()
            # this is tricky, we need to restore the state before returning
            # so update the p4_state and then move on to return the expression
            # this technique preserves the return value
            if isinstance(p4z3_expr, P4Context):
                p4_state = p4z3_expr.restore_context(p4_state)
                break
        # since we popped the P4Context object that would take care of this
        # return the z3 expressions of the state AFTER restoring it
        if expr is None:
            p4z3_expr = p4_state.pop_next_expr()
            expr = p4z3_expr.eval(p4_state)
        return expr