--- dumps/pruned/issue1863-BMV2::SimpleSwitchMidEnd_24_ConstantFolding.p4	2019-06-08 18:32:16.001597700 +0200
+++ dumps/pruned/issue1863-BMV2::SimpleSwitchMidEnd_25_LocalCopyPropagation.p4	2019-06-08 18:32:16.003665100 +0200
@@ -3,17 +3,12 @@ struct S {
     bit<1> b;
 }
 control c(out bit<1> b) {
-    S s;
     apply {
         {
-            s.a = 1w0;
-            s.b = 1w1;
         }
         {
-            s.a = s.b;
-            s.b = s.a;
         }
-        b = s.a;
+        b = 1w1;
     }
 }
 control e<T>(out T t);
