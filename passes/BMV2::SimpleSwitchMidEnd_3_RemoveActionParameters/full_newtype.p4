#include <core.p4>
typedef bit<32> B32;
typedef bit<32> N32;
struct S {
    B32 b;
    N32 n;
}
header H {
    N32 field;
}
control c(out B32 x) {
    N32 k;
    bit<32> b_1;
    N32 n_1;
    N32 n1;
    S s;
    @name(".NoAction") action NoAction_0() {
    }
    @name("c.t") table t {
        actions = {
            NoAction_0();
        }
        key = {
            k: exact @name("k") ;
        }
        default_action = NoAction_0();
    }
    apply {
        b_1 = 32w0;
        n_1 = b_1;
        k = n_1;
        x = (B32)n_1;
        n1 = 32w1;
        if (n_1 == n1) 
            x = 32w2;
        s.b = b_1;
        s.n = n_1;
        t.apply();
        if (s.b == (B32)s.n) 
            x = 32w3;
    }
}
control e(out B32 x);
package top(e _e);
top(c()) main;
