--- before_pass
+++ after_pass
@@ -10,7 +10,10 @@ control ctrl() {
         default_action = e();
     }
     apply {
-        tmp = t_0.apply().hit;
+        if (t_0.apply().hit) 
+            tmp = true;
+        else 
+            tmp = false;
         if (tmp) 
             t_0.apply();
         else 