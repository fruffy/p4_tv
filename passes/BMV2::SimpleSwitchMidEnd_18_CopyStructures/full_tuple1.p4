extern void f<T>(in T data);
control proto();
package top(proto _p);
struct tuple_0 {
    bit<32> field;
    bool    field_0;
}
control c() {
    tuple_0 x;
    apply {
        {
            x.field = 32w10;
            x.field_0 = false;
        }
        f<tuple_0>(x);
    }
}
top(c()) main;