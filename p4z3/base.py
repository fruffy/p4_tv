import operator as op
from collections import deque, OrderedDict
import copy
import logging
import z3
import types

log = logging.getLogger(__name__)


def z3_cast(val, to_type):

    if isinstance(val, (z3.BoolSortRef, z3.BoolRef)):
        # Convert boolean variables to a bit vector representation
        # TODO: Streamline bools and their evaluation
        val = z3.If(val, z3.BitVecVal(1, 1), z3.BitVecVal(0, 1))

    if isinstance(to_type, z3.BoolSortRef):
        # casting to a bool is simple, just check if the value is equal to 1
        # this works for bitvectors and integers, we convert any bools before
        return val == z3.BitVecVal(1, 1)

    # from here on we assume we are working with integer or bitvector types
    if isinstance(to_type, (z3.BitVecSortRef)):
        # It can happen that we get a bitvector type as target, get its size.
        to_type_size = to_type.size()
    else:
        to_type_size = to_type

    if isinstance(val, int):
        # It can happen that we get an int, cast it to a bit vector.
        return z3.BitVecVal(val, to_type_size)
    val_size = val.size()

    if val_size < to_type_size:
        # the target value is larger, extend with zeros
        return z3.ZeroExt(to_type_size - val_size, val)
    else:
        # the target value is smaller, truncate everything on the right
        return z3.Extract(to_type_size - 1, 0, val)


class P4Instance():
    def __new__(cls, z3_reg, method_name, *args, **kwargs):
        # global instances typically do not have any state so pass None here
        return z3_reg._globals[method_name](None, *args, **kwargs)


class P4Z3Class():
    def eval(self, p4_state):
        raise NotImplementedError("Method eval not implemented!")


class P4Expression(P4Z3Class):
    def eval(self, p4_state):
        raise NotImplementedError("Method eval not implemented!")


class P4Statement(P4Z3Class):
    def eval(self, p4_state):
        raise NotImplementedError("Method eval not implemented!")


class EndExpr(P4Expression):
    ''' This function is a little trick to ensure that chains are executed
        appropriately. When we reach the end of an execution chain, this
        expression returns the state of the program at the end of this
        particular chain.'''

    def eval(self, p4_state):
        return p4_state.get_z3_repr()


class P4Exit(P4Expression):

    def eval(self, p4_state):
        # Exit the chain early and absolutely
        p4_state.clear_expr_chain()
        return p4_state.get_z3_repr()


class P4Member(P4Expression):

    def __init__(self, lval, member):
        self.lval = lval
        self.member = member

    def eval(self, p4_state):
        lval = self.lval
        member = self.member
        while isinstance(lval, P4Member):
            lval = lval.eval(p4_state)
        while isinstance(member, P4Member):
            member = member.eval(p4_state)
        if isinstance(lval, P4Z3Class):
            lval = p4_state.resolve_expr(lval)
            return getattr(lval, member)
        return f"{lval}.{member}"


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


class AbstractP4Slice(P4Expression):
    ''' Abstract class '''

    def __init__(self, val, slice_l, slice_r):
        self.val = val
        self.slice_l = slice_l
        self.slice_r = slice_r

    def eval(self, p4_state):
        raise NotImplementedError("Method eval not implemented!")


class P4ComplexType():
    """ A P4ComplexType is a wrapper for any type that is not a simple Z3 type
    such as IntSort, BitVecSort or BoolSort.
    A P4ComplexType creates an instance of a Z3 DataTypeRef, all subtypes
    become members of this class and be accessed in dot-notation
    (e.g., headers.eth.srcmac).
    If one of the children is a DataTypeRef a new P4ComplexType will be
    instantiated and attached as member.
    Every member of this class should either be a P4ComplexType or a z3.SortRef
     if it is a basic type. A DataTypeRef should never be a member and always
    needs to be converted to a P4ComplexType.
    """

    def __init__(self, z3_reg, z3_type: z3.SortRef, name):
        self.name = name
        self.z3_type = z3_type
        self.const = z3.Const(f"{name}_0", z3_type)
        self.constructor = z3_type.constructor(0)
        self._set_z3_members(z3_reg, z3_type, self.constructor)

    def _set_z3_members(self, z3_reg, z3_type, constructor):
        self.members = OrderedDict()
        for type_index in range(constructor.arity()):
            member = z3_type.accessor(0, type_index)
            member_name = member.name()
            arg_type = member.range()
            if isinstance(arg_type, z3.DatatypeSortRef):
                # this is a complex datatype, create a P4ComplexType
                member_cls = z3_reg.instance("", arg_type)
                # and add it to the members, this is a little inefficient...
                setattr(self, member_name, member_cls)
                # since the child type is dependent on its parent
                # we propagate the parent constant down to all members
                member_cls.propagate_type(member(self.const))
            else:
                # use the default z3 constructor
                setattr(self, member_name, member(self.const))
            self.members[member_name] = member

    def propagate_type(self, parent_const: z3.AstRef):
        members = []
        for member_name, member_constructor in self.members.items():
            # a z3 constructor dependent on the parent constant
            z3_member = member_constructor(parent_const)
            # retrieve the member we are accessing
            member = self.resolve_reference(member_name)
            if isinstance(member, P4ComplexType):
                # it is a complex type
                # propagate the parent constant to all children
                member.propagate_type(z3_member)
            else:
                # a simple z3 type, just update the constructor
                setattr(self, member_name, z3_member)
            members.append(z3_member)

    def get_z3_repr(self, parent_const=None) -> z3.DatatypeRef:
        ''' This method returns the current representation of the object in z3
        logic. If there is no parent constant provided, use the z3 constant
        variable of the object and propagate it through all its children.'''
        members = []
        if parent_const is None:
            parent_const = self.const

        for member_name, member_constructor in self.members.items():
            member_make = self.resolve_reference(member_name)
            if isinstance(member_make, P4ComplexType):
                # we have a complex type
                # retrieve the member and call the constructor
                sub_const = member_constructor(parent_const)
                # call the constructor of the complex type
                members.append(member_make.get_z3_repr(sub_const))
            else:
                members.append(member_make)
        return self.constructor(*members)

    def resolve_reference(self, var):
        log.debug("Resolving reference %s", var)
        if isinstance(var, str):
            var = op.attrgetter(var)(self)
        return var

    def set_list(self, rvals):
        for index, member_name in enumerate(self.members):
            val = rvals[index]
            self.set_or_add_var(member_name, val)

    def set_or_add_var(self, lval, rval):
        # TODO: Fix this method, has hideous performance impact
        if hasattr(self, lval):
            tmp_lval = self.resolve_reference(lval)
            # the target variable exists
            # do not override an existing variable with a string reference!
            # resolve any possible rvalue reference
            log.debug("Recursing with %s and %s ", lval, rval)
            rval = self.resolve_reference(rval)
            if isinstance(rval, list):
                tmp_lval.set_list(rval)
                return
            # We also must handle integer values and convert them to bitvectors
            # For that we have to match the type
            if isinstance(rval, int) and isinstance(tmp_lval, z3.BitVecRef):
                # if the lvalue is a bit vector, try to cast it
                # otherwise ignore and hope that keeping it as an int works out
                rval = z3.BitVecVal(rval, tmp_lval.size())

        # now that all the preprocessing is done we can assign the value
        log.debug("Setting %s(%s) to %s(%s) ",
                  lval, type(lval), rval, type(rval))
        if '.' in lval:
            # this means we are accessing a complex member
            # get the parent class and update its value
            prefix, suffix = lval.rsplit(".", 1)
            # prefix may be a pointer to an actual complex type, resolve it
            target_class = self.resolve_reference(prefix)
            target_class.set_or_add_var(suffix, rval)
        else:
            setattr(self, lval, rval)

    def __eq__(self, other):

        # It can happen that we compare to a list
        # comparisons are almost the same just do not use members
        if isinstance(other, P4ComplexType):
            other_list = []
            for other_member_name in other.members:
                other_list.append(other.resolve_reference(other_member_name))
        elif isinstance(other, list):
            other_list = other
        else:
            return z3.BoolVal(False)

        # there is a mismatch in members, clearly not equal
        if len(self.members.keys()) != len(other_list):
            return z3.BoolVal(False)

        eq_members = []
        for index, self_member_name in enumerate(self.members):
            self_member = self.resolve_reference(self_member_name)
            other_member = other_list[index]
            # we compare the members of each complex type
            z3_eq = self_member == other_member
            eq_members.append(z3_eq)
        return z3.And(*eq_members)

    def __copy__(self):
        cls = self.__class__
        result = cls.__new__(cls)
        result.__dict__.update(self.__dict__)
        for name, val in result.__dict__.items():
            if isinstance(val, (P4ComplexType, deque)):
                result.__dict__[name] = copy.copy(val)
        return result


class Header(P4ComplexType):

    def __init__(self, z3_reg, z3_type, name):
        self.valid = z3.Bool(f"{name}_valid")
        super(Header, self).__init__(z3_reg, z3_type, name)

    def set_list(self, rvals):
        self.valid = z3.BoolVal(True)
        P4ComplexType.set_list(self, rvals)

    def isValid(self, p4_state):
        # This is a built-in
        return self.valid

    def setValid(self, p4_state):
        # This is a built-in
        self.valid = z3.BoolVal(True)
        return p4_state.get_z3_repr()

    def setInvalid(self, p4_state):
        # This is a built-in
        self.valid = z3.BoolVal(False)
        return p4_state.get_z3_repr()

    def __eq__(self, other):
        if isinstance(other, Header):
            # correspond to the P4 semantics for comparing headers
            # when both headers are invalid return true
            check_invalid = z3.And(z3.Not(self.valid),
                                   z3.Not(other.valid))
            # when both headers are valid compare the values
            check_valid = z3.And(self.valid, other.valid)
            self_const = self.get_z3_repr()
            other_const = other.get_z3_repr()
            comparison = z3.And(check_valid, self_const == other_const)
            return z3.Or(check_invalid, comparison)
        return super().__eq__(other)


class HeaderUnion(Header):
    # TODO: Implement this class correctly...
    pass


class HeaderStack(P4ComplexType):

    def __init__(self, z3_reg, z3_type, name):
        super(HeaderStack, self).__init__(z3_reg, z3_type, name)
        self.size = len(self.members)
        self.next_idx = 0

    def push_front(self, p4_state, num):
        # This is a built-in
        # TODO: Check if this implementation makes sense
        for hdr_idx in range(1, num):
            hdr_idx = hdr_idx - 1
            try:
                hdr = self.resolve_reference(f"{hdr_idx}")
                hdr.valid = z3.BoolVal(True)
            except AttributeError:
                pass
        return p4_state.get_z3_repr()

    def pop_front(self, p4_state, num):
        # This is a built-in
        # TODO: Check if this implementation makes sense
        for hdr_idx in range(1, num):
            hdr_idx = hdr_idx - 1
            try:
                hdr = self.resolve_reference(f"{hdr_idx}")
                hdr.valid = z3.BoolVal(False)
            except AttributeError:
                pass
        return p4_state.get_z3_repr()

    @property
    def next(self):
        # This is a built-in
        # TODO: Check if this implementation makes sense
        try:
            hdr = getattr(self, f"{self.next_idx}")
        except AttributeError:
            # if the header does not exist use it to break out of the loop?
            return P4Exit()
        return hdr

    @property
    def last(self):
        # This is a built-in
        # TODO: Check if this implementation makes sense
        last = 0 if self.size < 1 else self.size - 1
        hdr = getattr(self, f"{last}")
        return hdr

    def __setattr__(self, name, val):
        # TODO: Fix this workaround for next attributes
        if name == "next":
            self.__setattr__(f"{self.next_idx}", val)
            self.next_idx += 1
        else:
            self.__dict__[name] = val


class Struct(P4ComplexType):
    pass


class Enum(P4ComplexType):

    def __init__(self, z3_reg, z3_type: z3.SortRef, name):
        super(Enum, self).__init__(z3_reg, z3_type, name)
        # override the members with fixed values
        # Instead of a z3 variable we assign a concrete number to each member
        for idx, member_name in enumerate(self.members):
            setattr(self, member_name, z3.BitVecVal(idx, 8))

    def propagate_type(self, parent_const: z3.AstRef):
        # Enums are static so they do not have variable types.
        pass

    def __eq__(self, other):
        if isinstance(other, z3.ExprRef):
            # if we compare to a z3 expression we are free to chose the value
            # it does not matter if we are out of range, this just means false
            # with this we can generate an interpretable type
            # TODO: Should the type differ per invocation?
            z3_type = other.sort()
            return z3.Const(self.name, z3_type) == other
        else:
            log.warning("Enum: Comparison to %s of type %s not supported",
                        other, type(other))
            return z3.BoolVal(False)


class P4State(P4ComplexType):
    """
    A P4State Object is a special, dynamic type of P4ComplexType. It represents
    the execution environment and its z3 representation is ultimately used to
    compare different programs. P4State is mostly just a wrapper for all inout
    values. It also manages the execution chain of the program.
    """

    def __init__(self, z3_reg, z3_type, name):
        # deques allow for much more efficient pop and append operations
        # this is all we do so this works well
        super(P4State, self).__init__(z3_reg, z3_type, name)
        self.expr_chain = deque()

    def _update(self):
        self.const = z3.Const(f"{self.name}_1", self.z3_type)

    def del_var(self, var_string):
        # simple wrapper for delattr
        delattr(self, var_string)

    def resolve_expr(self, expr):
        # Resolves to z3 and z3p4 expressions, ints, lists, and dicts are also okay
        # resolve potential string references first
        log.debug("Resolving %s", expr)
        if isinstance(expr, str):
            val = self.resolve_reference(expr)
        else:
            val = expr
        if isinstance(val, P4Expression):
            # We got a P4 type, recurse...
            val = val.eval(self)
            return self.resolve_expr(val)
        if isinstance(val, (z3.AstRef, int)):
            # These are z3 types and can be returned
            # Unfortunately int is part of it because z3 is very inconsistent
            # about var handling...
            return val
        if isinstance(val, (P4ComplexType, P4Z3Class, types.MethodType)):
            # If we get a whole class return a new reference to the object
            # Do not return the z3 type because we may assign a complete structure
            # In a similar manner, just return any remaining class types
            # Methods can be class attributes and also need to be returned as is
            return val
        if isinstance(val, list):
            # For lists, resolve each value individually and return a new list
            list_expr = []
            for val_expr in val:
                rval_expr = self.resolve_expr(val_expr)
                list_expr.append(rval_expr)
            return list_expr
        if isinstance(val, dict):
            # For dicts, resolve each value individually and return a new dict
            dict_expr = []
            for name, val_expr in val.items():
                rval_expr = self.resolve_expr(val_expr)
                dict_expr[name] = rval_expr
            return dict_expr
        raise TypeError(f"Value of type {type(val)} cannot be resolved!")

    def find_nested_slice(self, lval, slice_l, slice_r):
        # gradually reduce the scope until we have calculated the right slice
        # also retrieve the string lvalue in the mean time
        if isinstance(lval, AbstractP4Slice):
            lval, _, outer_slice_r = self.find_nested_slice(
                lval.val, lval.slice_l, lval.slice_r)
            slice_l = outer_slice_r + slice_l
            slice_r = outer_slice_r + slice_r
        return lval, slice_l, slice_r

    def set_slice(self, lval, rval):
        slice_l = lval.slice_l
        slice_r = lval.slice_r
        lval = lval.val
        lval, slice_l, slice_r = self.find_nested_slice(lval, slice_l, slice_r)

        # need to resolve everything first
        lval_expr = self.resolve_expr(lval)
        rval_expr = self.resolve_expr(rval)
        # stupid integer checks that are unfortunately necessary....
        if isinstance(lval_expr, int):
            lval_expr = z3.BitVecVal(lval_expr, 64)
        if isinstance(rval_expr, int):
            rval_expr = z3.BitVecVal(rval_expr, 64)
        lval_expr_max = lval_expr.size() - 1
        if slice_l == lval_expr_max and slice_r == 0:
            # slice is full lval, nothing to do
            self.set_or_add_var(lval, rval_expr)
            return
        assemble = []
        if slice_l < lval_expr_max:
            # left slice is smaller than the max, leave that chunk unchanged
            assemble.append(z3.Extract(lval_expr_max, slice_l + 1, lval_expr))
        # fill the rval_expr into the slice
        # this cast is necessary to match the margins and to handle integers
        rval_expr = z3_cast(rval_expr, slice_l + 1 - slice_r)
        assemble.append(rval_expr)
        if slice_r > 0:
            # right slice is larger than zero, leave that chunk unchanged
            assemble.append(z3.Extract(slice_r - 1, 0, lval_expr))
        rval_expr = z3.Concat(*assemble)
        self.set_or_add_var(lval, rval_expr)
        return

    def set_or_add_var(self, lval, rval):
        if isinstance(lval, P4Member):
            lval = lval.eval(self)
        if isinstance(lval, AbstractP4Slice):
            self.set_slice(lval, rval)
            return
        P4ComplexType.set_or_add_var(self, lval, rval)
        # as soon as we have updated a variable in this state object
        # we update the constant
        self._update()

    def add_globals(self, globals_values):
        for extern_name, extern_method in globals_values.items():
            self.set_or_add_var(extern_name, extern_method)

    def clear_expr_chain(self):
        self.expr_chain.clear()

    def copy_expr_chain(self):
        return self.expr_chain.copy()

    def set_expr_chain(self, expr_chain):
        self.expr_chain = deque(expr_chain)

    def insert_exprs(self, exprs):
        if isinstance(exprs, list):
            self.expr_chain.extendleft(reversed(exprs))
        else:
            self.expr_chain.appendleft(exprs)

    def pop_next_expr(self):
        if self.expr_chain:
            return self.expr_chain.popleft()
        return EndExpr()


class Z3Reg():
    def __init__(self):
        self._types = {}
        self._globals = {}
        self._classes = {}
        self._ref_count = {}

    def _register_structlike(self, name, p4_class, z3_args):
        self._types[name] = z3.Datatype(name)
        self._types[name].declare(f"mk_{name}", *z3_args)
        self._types[name] = self._types[name].create()
        self._classes[name] = p4_class
        self._ref_count[name] = 0

    def declare_global(self, type_str, name, global_val):
        type_str = type_str.lower()
        if type_str == "header":
            self._register_structlike(name, Header, global_val)
        elif type_str == "struct":
            self._register_structlike(name, Struct, global_val)
        elif type_str == "stack":
            self._register_structlike(name, HeaderStack, global_val)
        elif type_str == "enum":
            # Enums are a bit weird... we first create a type
            enum_types = []
            for enum_name in global_val:
                enum_types.append((enum_name, z3.BitVecSort(8)))
            self._register_structlike(name, Enum, enum_types)
            # And then actually instantiate it so we can reference it later
            self._globals[name] = self.instance(name, self._types[name])
        elif type_str == "typedef":
            self._types[name] = global_val
            self._classes[name] = global_val
            self._ref_count[name] = 0
        elif type_str == "extern":
            # Extern also serve as types, so we need to register them too
            self._types[name] = global_val
            self._globals[name] = global_val
        else:
            self._globals[name] = global_val
            self._types[name] = global_val

    def init_p4_state(self, name, p4_params):
        stripped_args = []
        instances = {}
        for param_name, param in p4_params.items():
            is_ref = param[0]
            param_type = param[1]
            if is_ref in ("inout", "out"):
                # only inouts or outs matter as output
                stripped_args.append((param_name, param_type))
            else:
                # for inputs we can instantiate something
                instance = self.instance(param_name, param_type)
                instances[param_name] = instance
        self._register_structlike(name, P4State, stripped_args)
        p4_state = self.instance(name, self.type(name))
        p4_state.add_globals(self._globals)
        for instance_name, instance_val in instances.items():
            p4_state.set_or_add_var(instance_name, instance_val)
        return p4_state

    def type(self, type_name):
        if type_name in self._types:
            return self._types[type_name]
        else:
            # lets be bold here and assume that a type that is not known
            # is a generic and can be declared as a generic sort
            val = z3.DeclareSort(type_name)
            self.declare_global("typedef", type_name, val)
            return self._types[type_name]

    def stack(self, z3_type, num):
        type_name = str(z3_type)
        z3_name = f"{type_name}{num}"
        stack_args = []
        for val in range(num):
            stack_args.append((f"{val}", z3_type))
        self.declare_global("stack", z3_name, stack_args)
        return self.type(z3_name)

    def instance(self, var_name, p4z3_type):
        if isinstance(p4z3_type, z3.DatatypeSortRef):
            type_name = str(p4z3_type)
            if not var_name:
                var_name = f"{type_name}_{self._ref_count[type_name]}"
            z3_cls = self._classes[type_name]
            self._ref_count[type_name] += 1
            instance = z3_cls(self, p4z3_type, var_name)
            return instance
        elif isinstance(p4z3_type, z3.SortRef):
            return z3.Const(f"{var_name}", p4z3_type)
        else:
            return p4z3_type
