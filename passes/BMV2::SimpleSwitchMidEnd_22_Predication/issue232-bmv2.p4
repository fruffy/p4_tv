--- dumps/p4_16_samples/issue232-bmv2.p4/pruned/issue232-bmv2-BMV2::SimpleSwitchMidEnd_21_RemoveSelectBooleans.p4	2019-05-20 17:30:36.346414900 +0200
+++ dumps/p4_16_samples/issue232-bmv2.p4/pruned/issue232-bmv2-BMV2::SimpleSwitchMidEnd_22_Predication.p4	2019-05-20 17:30:36.351885500 +0200
@@ -40,13 +40,21 @@ control Eg(inout Headers hdrs, inout Met
         }
         done = false;
         ok = !done && same;
-        if (ok) {
+        {
+            bool cond;
             {
-                val_2.field1 = val_1.field1;
-            }
-            val_2.field1 = 32w8;
-            {
-                val_1.field1 = val_2.field1;
+                bool pred;
+                cond = ok;
+                pred = cond;
+                {
+                    {
+                        val_2.field1 = (pred ? val_1.field1 : val_2.field1);
+                    }
+                    val_2.field1 = (pred ? 32w8 : val_2.field1);
+                    {
+                        val_1.field1 = (pred ? val_2.field1 : val_1.field1);
+                    }
+                }
             }
         }
     }
