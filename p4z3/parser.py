from p4z3.base import log, copy, z3
from p4z3.base import P4Exit, P4Z3Class, P4End
from p4z3.callables import P4Control


class P4Parser(P4Control):
    pass


class ParserTree(P4Z3Class):

    def __init__(self):
        self.states = {}
        self.exit_states = ["accept", "reject"]

    def add_state(self, state_name, state):
        self.states[state_name] = state

    def eval(self, p4_state):
        for state_name, state in self.states.items():
            p4_state.set_or_add_var(state_name, state)
        for state_name in self.exit_states:
            p4_state.set_or_add_var(state_name, P4Exit())

        return self.states["start"].eval(p4_state)


class ParserState(P4Z3Class):

    def __init__(self):
        self.exprs = []
        self.select = P4End()

    def add_stmt(self, expr):
        self.exprs.append(expr)

    def add_select(self, select):
        self.select = select

    def eval(self, p4_state):
        select = p4_state.resolve_reference(self.select)
        self.exprs.append(select)
        p4_state.insert_exprs(self.exprs)
        p4z3_expr = p4_state.pop_next_expr()
        return p4z3_expr.eval(p4_state)


class ParserSelect(P4Z3Class):
    def __init__(self, match, *cases):
        self.match = match
        self.cases = []
        self.default = "accept"
        for case_key, case_state in cases:
            if str(case_key) == "default":
                self.default = case_state
            else:
                self.cases.append((case_key, case_state))

    def eval(self, p4_state):
        p4_state_cpy = copy.copy(p4_state)
        expr = p4_state.resolve_expr(self.default)
        for case_val, case_name in reversed(self.cases):
            case_expr = p4_state.resolve_expr(case_val)
            select_cond = []
            if isinstance(case_expr, list):
                for idx, case_match in enumerate(case_expr):
                    match = self.match[idx]
                    match_expr = p4_state.resolve_expr(match)
                    cond = match_expr == case_match
                    select_cond.append(cond)
            else:
                for match in self.match:
                    match_expr = p4_state.resolve_expr(match)
                    cond = match_expr == case_expr
                    select_cond.append(cond)
            if not select_cond:
                select_cond = [z3.BoolVal(False)]
            state_expr = copy.copy(p4_state_cpy).resolve_expr(case_name)
            expr = z3.If(z3.And(*select_cond), state_expr, expr)

        return expr