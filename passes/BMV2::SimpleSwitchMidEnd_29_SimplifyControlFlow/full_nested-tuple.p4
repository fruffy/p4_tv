struct T {
    bit<1> f;
}
struct tuple_1 {
    T field_1;
    T field_2;
}
struct S {
    tuple_1 f1;
    T       f2;
    bit<1>  z;
}
struct tuple_0 {
    T field;
    T field_0;
}
extern void f<T>(in T data);
control c(inout bit<1> r) {
    T s_f1_field;
    T s_f1_field_0;
    T s_f2;
    apply {
        s_f1_field.f = 1w0;
        s_f1_field_0.f = 1w1;
        s_f2.f = 1w0;
        f<tuple_1>({ s_f1_field, s_f1_field_0 });
        f<tuple_0>({ { 1w0 }, { 1w1 } });
        r = s_f2.f & 1w1;
    }
}
control simple(inout bit<1> r);
package top(simple e);
top(c()) main;
