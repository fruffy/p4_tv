control ctrl(out bit<32> c) {
    @name("ctrl.e") action e_0() {
        exit;
    }
    @name("ctrl.e") action e_2() {
        exit;
    }
    apply {
        c = 32w2;
        e_0();
        c = 32w5;
    }
}
control noop(out bit<32> c);
package p(noop _n);
p(ctrl()) main;
