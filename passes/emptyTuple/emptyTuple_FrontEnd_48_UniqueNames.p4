typedef tuple<> emptyTuple;
control c(out bool b) {
    emptyTuple t;
    apply {
        t = {  };
        if (t == {  }) {
            b = true;
        } else {
            b = false;
        }
    }
}
control e(out bool b);
package top(e _e);
top(c()) main;
