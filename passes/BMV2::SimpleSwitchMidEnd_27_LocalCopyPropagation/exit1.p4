--- before_pass
+++ after_pass
@@ -1,8 +1,6 @@
 control ctrl() {
-    bit<32> a_0;
     apply {
-        a_0 = 32w0;
-        if (a_0 == 32w0) 
+        if (32w0 == 32w0) 
             exit;
         else 
             exit;