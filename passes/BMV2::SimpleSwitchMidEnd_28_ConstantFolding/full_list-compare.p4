struct S {
    bit<32> l;
    bit<32> r;
}
control c(out bool z);
package top(c _c);
struct tuple_0 {
    bit<32> field;
    bit<32> field_0;
}
control test(out bool zout) {
    apply {
        zout = true;
        zout = true;
    }
}
top(test()) main;
