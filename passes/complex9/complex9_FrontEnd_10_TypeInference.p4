extern bit<32> f(in bit<32> x);
control c(inout bit<32> r) {
    apply {
        if (f(32w2) > 32w0 && f(32w3) < 32w0) {
            r = (bit<32>)32w1;
        } else {
            r = (bit<32>)32w2;
        }
    }
}
control simple(inout bit<32> r);
package top(simple e);
top(c()) main;
