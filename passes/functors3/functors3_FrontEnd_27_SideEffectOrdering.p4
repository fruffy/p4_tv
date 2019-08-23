#include <core.p4>
parser p1(out bit<1> z1)(bit<1> b1) {
    state start {
        {
            z1 = b1;
        }
        transition accept;
    }
}
parser p(out bit<1> z)(bit<1> b, bit<1> c) {
    @name("p1i") p1(b) p1i_0;
    state start {
        {
            p1i_0.apply(z);
        }
        {
            z = z & b & c;
        }
        transition accept;
    }
}
parser simple(out bit<1> z);
package m(simple n);
m(p(1w0, 1w1)) main;
