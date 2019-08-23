#include <core.p4>
control E(out bit<1> b);
control D(out bit<1> b) {
    apply {
        b = 1w1;
    }
}
control F(out bit<1> b) {
    apply {
        b = 1w0;
    }
}
control C(out bit<1> b)(E d) {
    apply {
        d.apply(b);
    }
}
control Ingress(out bit<1> b) {
    @name("d") D() d_0;
    @name("f") F() f_0;
    @name("c0") C(d_0) c0_0;
    @name("c1") C(f_0) c1_0;
    apply {
        c0_0.apply(b);
        c1_0.apply(b);
    }
}
package top(E _e);
top(Ingress()) main;