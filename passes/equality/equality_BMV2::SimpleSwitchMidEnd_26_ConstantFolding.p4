header H {
    bit<32>    a;
    varbit<32> b;
}
struct S {
    bit<32> a;
    H       h;
}
control c(out bit<1> x) {
    varbit<32> a_0;
    varbit<32> b_0;
    H h1_0;
    H h2_0;
    bit<32> s1_0_a;
    H s1_0_h;
    bit<32> s2_0_a;
    H s2_0_h;
    H[2] a1_0;
    H[2] a2_0;
    apply {
        if (a_0 == b_0) {
            x = 1w1;
        } else if (!h1_0.isValid() && !h2_0.isValid() || h1_0.isValid() && h2_0.isValid() && h1_0.a == h2_0.a && h1_0.b == h2_0.b) {
            x = 1w1;
        } else if (s1_0_a == s2_0_a && (!s1_0_h.isValid() && !s2_0_h.isValid() || s1_0_h.isValid() && s2_0_h.isValid() && s1_0_h.a == s2_0_h.a && s1_0_h.b == s2_0_h.b)) {
            x = 1w1;
        } else if ((!a1_0[0].isValid() && !a2_0[0].isValid() || a1_0[0].isValid() && a2_0[0].isValid() && a1_0[0].a == a2_0[0].a && a1_0[0].b == a2_0[0].b) && (!a1_0[1].isValid() && !a2_0[1].isValid() || a1_0[1].isValid() && a2_0[1].isValid() && a1_0[1].a == a2_0[1].a && a1_0[1].b == a2_0[1].b)) {
            x = 1w1;
        } else {
            x = 1w0;
        }
    }
}
control ctrl(out bit<1> x);
package top(ctrl _c);
top(c()) main;
