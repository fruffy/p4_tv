--- before_pass
+++ after_pass
@@ -2,10 +2,18 @@
 control Ing(out bit<32> a) {
     bool b_0;
     @name("Ing.cond") action cond() {
-        if (b_0) 
-            a = 32w5;
-        else 
-            a = 32w10;
+        {
+            bool cond_0;
+            {
+                bool pred;
+                cond_0 = b_0;
+                pred = cond_0;
+                a = (pred ? 32w5 : a);
+                cond_0 = !cond_0;
+                pred = cond_0;
+                a = (pred ? 32w10 : a);
+            }
+        }
     }
     apply {
         b_0 = true;