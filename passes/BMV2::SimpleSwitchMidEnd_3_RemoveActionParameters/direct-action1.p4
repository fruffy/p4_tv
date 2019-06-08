--- dumps/pruned/direct-action1-BMV2::SimpleSwitchMidEnd_2_EliminateSerEnums.p4	2019-06-08 18:31:31.816022800 +0200
+++ dumps/pruned/direct-action1-BMV2::SimpleSwitchMidEnd_3_RemoveActionParameters.p4	2019-06-08 18:31:31.833293600 +0200
@@ -1,11 +1,13 @@
 control c(inout bit<16> y) {
     bit<32> x;
-    @name("c.a") action a_0(bit<32> arg) {
+    bit<32> arg;
+    @name("c.a") action a_0() {
+        arg = x;
         y = (bit<16>)arg;
     }
     apply {
         x = 32w10;
-        a_0(x);
+        a_0();
     }
 }
 control proto(inout bit<16> y);
