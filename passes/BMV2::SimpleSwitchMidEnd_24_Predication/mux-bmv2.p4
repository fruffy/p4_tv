--- before_pass
+++ after_pass
@@ -23,10 +23,18 @@ control Eg(inout Headers hdrs, inout Met
         p_1 = true;
         val = res_0;
         _sub_0 = val[31:0];
-        if (p_1) 
-            tmp = _sub_0;
-        else 
-            tmp = 32w1;
+        {
+            bool cond;
+            {
+                bool pred;
+                cond = p_1;
+                pred = cond;
+                tmp = (pred ? _sub_0 : tmp);
+                cond = !cond;
+                pred = cond;
+                tmp = (pred ? 32w1 : tmp);
+            }
+        }
         _sub_0 = tmp;
         val[31:0] = _sub_0;
         res_0 = val;