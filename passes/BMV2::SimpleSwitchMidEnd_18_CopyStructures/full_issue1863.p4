struct S {
    bit<1> a;
    bit<1> b;
}
control c(out bit<1> b) {
    S s;
    apply {
        {
            s.a = 1w0;
            s.b = 1w1;
        }
        {
            s.a = s.b;
            s.b = s.a;
        }
        b = s.a;
    }
}
control e<T>(out T t);
package top<T>(e<T> e);
top<bit<1>>(c()) main;
