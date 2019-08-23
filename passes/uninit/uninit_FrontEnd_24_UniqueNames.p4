#include <core.p4>
header Header {
    bit<32> data1;
    bit<32> data2;
    bit<32> data3;
}
extern void func(in Header h);
extern bit<32> g(inout bit<32> v, in bit<32> w);
parser p1(packet_in p, out Header h) {
    Header[2] stack_0;
    bool b_0;
    bool c_0;
    bool d_0;
    state start {
        h.data1 = 32w0;
        func(h);
        g(h.data2, g(h.data2, h.data2));
        h.data2 = h.data3 + 32w1;
        stack_0[0] = stack_0[1];
        b_0 = stack_0[1].isValid();
        transition select(h.isValid()) {
            true: next1;
            false: next2;
        }
    }
    state next1 {
        d_0 = false;
        transition next3;
    }
    state next2 {
        c_0 = true;
        d_0 = c_0;
        transition next3;
    }
    state next3 {
        c_0 = !c_0;
        d_0 = !d_0;
        transition accept;
    }
}
control c(out bit<32> v) {
    bit<32> b_1;
    bit<32> d_1 = 32w1;
    bit<32> setByAction_0;
    @name("a1") action a1_0() {
        setByAction_0 = 32w1;
    }
    @name("a2") action a2_0() {
        setByAction_0 = 32w1;
    }
    @name("t") table t_0 {
        actions = {
            a1_0();
            a2_0();
        }
        default_action = a1_0();
    }
    apply {
        b_1 = b_1 + 32w1;
        d_1 = d_1 + 32w1;
        bit<32> e_0;
        bit<32> f_0;
        if (e_0 > 32w0) {
            e_0 = 32w1;
            f_0 = 32w2;
        } else {
            f_0 = 32w3;
        }
        e_0 = e_0 + 32w1;
        bool touched_0;
        switch (t_0.apply().action_run) {
            a1_0: {
                touched_0 = true;
            }
        }
        touched_0 = !touched_0;
        if (e_0 > 32w0) {
            t_0.apply();
        } else {
            a1_0();
        }
        setByAction_0 = setByAction_0 + 32w1;
    }
}
parser proto(packet_in p, out Header h);
control cproto(out bit<32> v);
package top(proto _p, cproto _c);
top(p1(), c()) main;