--- dumps/p4_16_samples/issue1452-1.p4/pruned/issue1452-1-BMV2::SimpleSwitchMidEnd_24_ConstantFolding.p4	2019-05-20 17:30:15.989499900 +0200
+++ dumps/p4_16_samples/issue1452-1.p4/pruned/issue1452-1-BMV2::SimpleSwitchMidEnd_25_LocalCopyPropagation.p4	2019-05-20 17:30:15.992576600 +0200
@@ -1,9 +1,5 @@
 control c() {
-    bit<32> x;
-    bit<32> arg;
     @name("c.b") action b_0() {
-        arg = 32w2;
-        x = arg;
     }
     apply {
         b_0();
