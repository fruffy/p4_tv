struct tuple_0 {
}
typedef tuple_0 emptyTuple;
control c(out bool b) {
    emptyTuple t_0;
    apply {
        t_0 = {  };
        if (true) 
            b = true;
        else 
            b = false;
    }
}
control e(out bool b);
package top(e _e);
top(c()) main;
