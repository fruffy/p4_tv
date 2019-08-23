struct PortId_t {
    bit<9> _v;
}
header H {
    bit<32> b;
}
struct metadata_t {
    PortId_t foo;
}
control I(inout metadata_t meta) {
    H h;
    apply {
        h.setValid();
        if (meta.foo == PortId_t {_v = 9w192}) {
            meta.foo._v = meta.foo._v + 9w1;
            h.setValid();
            h = H {b = 32w2};
            if (h == H {b = 32w1}) {
                h.setValid();
            }
        }
    }
}
control C<M>(inout M m);
package top<M>(C<M> c);
top<metadata_t>(I()) main;
