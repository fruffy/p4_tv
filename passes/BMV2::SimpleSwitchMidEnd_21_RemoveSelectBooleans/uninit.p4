--- dumps/pruned/uninit-BMV2::SimpleSwitchMidEnd_20_SimplifySelectList.p4	2019-06-08 18:34:19.390332700 +0200
+++ dumps/pruned/uninit-BMV2::SimpleSwitchMidEnd_21_RemoveSelectBooleans.p4	2019-06-08 18:34:19.393716100 +0200
@@ -25,9 +25,9 @@ parser p1(packet_in p, out Header h) {
         g(h.data2, tmp_6);
         h.data2 = h.data3 + 32w1;
         stack[1].isValid();
-        transition select(h.isValid()) {
-            true: next1;
-            false: next2;
+        transition select((bit<1>)h.isValid()) {
+            (bit<1>)true: next1;
+            (bit<1>)false: next2;
         }
     }
     state next1 {
