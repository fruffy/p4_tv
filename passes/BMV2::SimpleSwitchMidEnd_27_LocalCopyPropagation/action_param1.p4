--- before_pass
+++ after_pass
@@ -1,8 +1,6 @@
 control c(inout bit<32> x) {
-    bit<32> arg_1;
     @name("c.a") action a() {
-        arg_1 = 32w15;
-        x = arg_1;
+        x = 32w15;
     }
     apply {
         a();