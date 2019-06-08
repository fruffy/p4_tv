--- dumps/pruned/issue1452-BMV2::SimpleSwitchMidEnd_2_EliminateSerEnums.p4	2019-06-08 18:32:01.947698100 +0200
+++ dumps/pruned/issue1452-BMV2::SimpleSwitchMidEnd_3_RemoveActionParameters.p4	2019-06-08 18:32:01.922370500 +0200
@@ -1,12 +1,16 @@
 control c() {
     bit<32> x;
-    @name("c.a") action a_0(inout bit<32> arg) {
-        bool hasReturned_0 = false;
+    bool hasReturned_0;
+    bit<32> arg;
+    @name("c.a") action a_0() {
+        arg = x;
+        hasReturned_0 = false;
         arg = 32w1;
         hasReturned_0 = true;
+        x = arg;
     }
     apply {
-        a_0(x);
+        a_0();
     }
 }
 control proto();
