--- dumps/p4_16_samples/issue210.p4/pruned/issue210-BMV2::SimpleSwitchMidEnd_21_RemoveSelectBooleans.p4	2019-05-20 17:30:35.644891300 +0200
+++ dumps/p4_16_samples/issue210.p4/pruned/issue210-BMV2::SimpleSwitchMidEnd_22_Predication.p4	2019-05-20 17:30:35.658144200 +0200
@@ -2,10 +2,18 @@
 control Ing(out bit<32> a) {
     bool b;
     @name("Ing.cond") action cond_0() {
-        if (b) 
-            a = 32w5;
-        else 
-            a = 32w10;
+        {
+            bool cond;
+            {
+                bool pred;
+                cond = b;
+                pred = cond;
+                a = (pred ? 32w5 : a);
+                cond = !cond;
+                pred = cond;
+                a = (pred ? 32w10 : a);
+            }
+        }
     }
     apply {
         b = true;
