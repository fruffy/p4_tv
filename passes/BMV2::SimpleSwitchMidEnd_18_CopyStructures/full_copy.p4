struct S {
    bit<32> x;
}
control c(inout bit<32> b) {
    S s1;
    S s2;
    @name("c.a") action a_0() {
        {
            s2.x = 32w0;
        }
        {
            s1.x = s2.x;
        }
        {
            s2.x = s1.x;
        }
        b = s2.x;
    }
    apply {
        a_0();
    }
}
control proto(inout bit<32> _b);
package top(proto _p);
top(c()) main;
