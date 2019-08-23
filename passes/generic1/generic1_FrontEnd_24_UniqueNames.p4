extern Generic<T> {
    Generic(T sz);
    R get<R>();
    R get1<R, S>(in S value, in R data);
}
extern void f<T>(in T arg);
control c<T>()(T size) {
    @name("x") Generic<T>(size) x_0;
    apply {
        bit<32> a_0 = x_0.get<bit<32>>();
        bit<5> b_0 = x_0.get1<bit<5>, bit<10>>(10w0, 5w0);
        f<bit<5>>(b_0);
    }
}
control caller() {
    @name("cinst") c<bit<8>>(8w9) cinst_0;
    apply {
        cinst_0.apply();
    }
}
control s();
package p(s parg);
p(caller()) main;
