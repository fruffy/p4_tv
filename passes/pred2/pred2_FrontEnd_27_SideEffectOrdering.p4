#include <core.p4>
#include <v1model.p4>
control empty();
package top(empty e);
control Ing() {
    bool b_0;
    bool tmp;
    bool tmp_0;
    @name("cond") action cond() {
        {
            b_0 = true;
        }
        {
            tmp = tmp;
        }
        {
            tmp_0 = tmp_0;
        }
        {
            tmp = tmp;
        }
    }
    @name("tbl_cond") table tbl_cond_0 {
        actions = {
            cond();
        }
        const default_action = cond();
    }
    apply {
        {
            tbl_cond_0.apply();
        }
    }
}
top(Ing()) main;