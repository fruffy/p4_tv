control c() {
    bit<32> x_0;
    @name("a") action a_0(inout bit<32> arg_0) {
        arg_0 = 32w1;
        return;
    }
    apply {
        a_0(x_0);
    }
}
control proto();
package top(proto p);
top(c()) main;
