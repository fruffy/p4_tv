extern E {
    E();
    bit<32> f(in bit<32> x);
}
control c(inout bit<32> r) {
    bit<32> tmp_2;
    bit<32> tmp_3;
    @name("c.e") E() e_1;
    apply {
        tmp_2 = e_1.f(32w4);
        tmp_3 = e_1.f(32w5);
        r = tmp_2 + tmp_3;
    }
}
control simple(inout bit<32> r);
package top(simple e);
top(c()) main;