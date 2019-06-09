extern bit<32> f(in bit<32> x);
control c(inout bit<32> r) {
    bit<32> tmp;
    bit<32> tmp_0;
    apply {
        tmp = f(32w4);
        tmp_0 = f(32w5);
        r = tmp + tmp_0;
    }
}
control simple(inout bit<32> r);
package top(simple e);
top(c()) main;
