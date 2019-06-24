#include <core.p4>
control c(out bool x) {
    bool tmp;
    bool tmp_0;
    bool tmp_1;
    @name(".NoAction") action NoAction_0() {
    }
    @name(".NoAction") action NoAction_3() {
    }
    @name("c.t1") table t1_0 {
        key = {
            x: exact @name("x") ;
        }
        actions = {
            NoAction_0();
        }
        default_action = NoAction_0();
    }
    @name("c.t2") table t2_0 {
        key = {
            x: exact @name("x") ;
        }
        actions = {
            NoAction_3();
        }
        default_action = NoAction_3();
    }
    apply {
        x = true;
        if (t1_0.apply().hit) 
            tmp = true;
        else 
            tmp = false;
        if (!tmp) 
            tmp_0 = false;
        else {
            if (t2_0.apply().hit) 
                tmp_1 = true;
            else 
                tmp_1 = false;
            tmp_0 = tmp_1;
        }
        if (tmp_0) 
            x = false;
    }
}
control proto(out bool x);
package top(proto p);
top(c()) main;