--- before_pass
+++ after_pass
@@ -8,21 +8,15 @@ extern void func(in Header h);
 extern bit<32> g(inout bit<32> v, in bit<32> w);
 parser p1(packet_in p, out Header h) {
     Header[2] stack_0;
-    bool c_0;
-    bool d_0;
     bit<32> tmp;
-    bit<32> tmp_0;
     bit<32> tmp_1;
-    bit<32> tmp_2;
     state start {
         h.data1 = 32w0;
         func(h);
         tmp = h.data2;
-        tmp_0 = h.data2;
-        tmp_1 = g(tmp, tmp_0);
+        tmp_1 = g(tmp, h.data2);
         h.data2 = tmp;
-        tmp_2 = tmp_1;
-        g(h.data2, tmp_2);
+        g(h.data2, tmp_1);
         h.data2 = h.data3 + 32w1;
         stack_0[1].isValid();
         transition select((bit<1>)h.isValid()) {
@@ -31,12 +25,9 @@ parser p1(packet_in p, out Header h) {
         }
     }
     state next1 {
-        d_0 = false;
         transition next3;
     }
     state next2 {
-        c_0 = true;
-        d_0 = c_0;
         transition next3;
     }
     state next3 {
@@ -44,18 +35,12 @@ parser p1(packet_in p, out Header h) {
     }
 }
 control c(out bit<32> v) {
-    bit<32> d_1;
-    bit<32> setByAction_0;
     bit<32> e_0;
-    bool touched_0;
     @name("c.a1") action a1() {
-        setByAction_0 = 32w1;
     }
     @name("c.a1") action a1_2() {
-        setByAction_0 = 32w1;
     }
     @name("c.a2") action a2() {
-        setByAction_0 = 32w1;
     }
     @name("c.t") table t_0 {
         actions = {
@@ -65,7 +50,6 @@ control c(out bit<32> v) {
         default_action = a1();
     }
     apply {
-        d_1 = 32w1;
         if (e_0 > 32w0) 
             e_0 = 32w1;
         else 
@@ -73,7 +57,6 @@ control c(out bit<32> v) {
         e_0 = e_0 + 32w1;
         switch (t_0.apply().action_run) {
             a1: {
-                touched_0 = true;
             }
         }
         if (e_0 > 32w0) 