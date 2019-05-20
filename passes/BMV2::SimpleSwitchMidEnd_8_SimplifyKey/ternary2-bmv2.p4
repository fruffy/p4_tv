--- dumps/p4_16_samples/ternary2-bmv2.p4/pruned/ternary2-bmv2-BMV2::SimpleSwitchMidEnd_7_TypeChecking.p4	2019-05-20 17:32:30.010249600 +0200
+++ dumps/p4_16_samples/ternary2-bmv2.p4/pruned/ternary2-bmv2-BMV2::SimpleSwitchMidEnd_8_SimplifyKey.p4	2019-05-20 17:32:30.013590100 +0200
@@ -93,9 +93,10 @@ control ingress(inout packet_t hdrs, ino
         }
         default_action = noop_0();
     }
+    bit<16> key_0;
     @name("ingress.ex1") table ex1 {
         key = {
-            hdrs.extra[0].h: ternary @name("hdrs.extra[0].h") ;
+            key_0: ternary @name("hdrs.extra[0].h") ;
         }
         actions = {
             setbyte_0();
@@ -138,15 +139,18 @@ control ingress(inout packet_t hdrs, ino
     }
     apply {
         test1.apply();
-        switch (ex1.apply().action_run) {
-            act1_0: {
-                tbl1.apply();
-            }
-            act2_0: {
-                tbl2.apply();
-            }
-            act3_0: {
-                tbl3.apply();
+        {
+            key_0 = hdrs.extra[0].h;
+            switch (ex1.apply().action_run) {
+                act1_0: {
+                    tbl1.apply();
+                }
+                act2_0: {
+                    tbl2.apply();
+                }
+                act3_0: {
+                    tbl3.apply();
+                }
             }
         }
     }
