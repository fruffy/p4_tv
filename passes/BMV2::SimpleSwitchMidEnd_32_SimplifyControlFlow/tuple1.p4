--- before_pass
+++ after_pass
@@ -8,10 +8,8 @@ struct tuple_0 {
 control c() {
     tuple_0 x_0;
     apply {
-        {
-            x_0.field = 32w10;
-            x_0.field_0 = false;
-        }
+        x_0.field = 32w10;
+        x_0.field_0 = false;
         f<tuple_0>(x_0);
     }
 }