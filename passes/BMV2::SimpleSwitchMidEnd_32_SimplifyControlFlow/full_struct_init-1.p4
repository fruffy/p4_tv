struct PortId_t {
    bit<9> _v;
}
header H {
    bit<32> b;
}
struct metadata_t {
    bit<9> _foo__v0;
}
control I(inout metadata_t meta) {
    H h_0;
    apply {
        h_0.setValid();
        if (meta._foo__v0 == 9w192) {
            meta._foo__v0 = meta._foo__v0 + 9w1;
            h_0.setValid();
            h_0.b = 32w2;
            if (!h_0.isValid() && false || h_0.isValid() && true && false) 
                h_0.setValid();
        }
    }
}
control C<M>(inout M m);
package top<M>(C<M> c);
top<metadata_t>(I()) main;
