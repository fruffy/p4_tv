control p(inout bit<1> bt) {
    @name("b") action b() {
        {
            bit<1> y0_0 = bt;
            y0_0 = y0_0 | 1w1;
            bt = y0_0;
        }
        {
            bit<1> y0_2 = bt;
            y0_2 = y0_2 | 1w1;
            bt = y0_2;
        }
    }
    @name("t") table t {
        actions = {
            b();
        }
        default_action = b();
    }
    apply {
        t.apply();
    }
}
control simple<T>(inout T arg);
package m<T>(simple<T> pipe);
m<bit<1>>(p()) main;