--- dumps/p4_16_samples/function.p4/pruned/function-BMV2::SimpleSwitchMidEnd_24_ConstantFolding.p4	2019-05-20 17:29:48.307077600 +0200
+++ dumps/p4_16_samples/function.p4/pruned/function-BMV2::SimpleSwitchMidEnd_25_LocalCopyPropagation.p4	2019-05-20 17:29:48.309898400 +0200
@@ -1,25 +1,19 @@
 control c(out bit<16> b) {
-    bit<16> tmp_0;
-    bit<16> left;
-    bit<16> right;
     bool hasReturned_0;
     bit<16> retval_0;
     apply {
         {
-            left = 16w10;
-            right = 16w12;
             hasReturned_0 = false;
-            if (left > right) {
+            if (16w10 > 16w12) {
                 hasReturned_0 = true;
-                retval_0 = left;
+                retval_0 = 16w10;
             }
             if (!hasReturned_0) {
                 hasReturned_0 = true;
-                retval_0 = right;
+                retval_0 = 16w12;
             }
-            tmp_0 = retval_0;
         }
-        b = tmp_0;
+        b = retval_0;
     }
 }
 control ctr(out bit<16> b);
