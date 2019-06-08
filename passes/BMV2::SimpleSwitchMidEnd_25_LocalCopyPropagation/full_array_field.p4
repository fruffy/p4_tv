header H {
    bit<1> z;
}
extern bit<32> f(inout bit<1> x, in bit<1> b);
control c(out H[2] h);
package top(c _c);
control my(out H[2] s) {
    bit<32> tmp_1;
    apply {
        s[32w0].z = 1w1;
        s[32w0 + 32w1].z = 1w0;
        tmp_1 = f(s[32w0].z, 1w0);
        f(s[tmp_1].z, 1w1);
    }
}
top(my()) main;
