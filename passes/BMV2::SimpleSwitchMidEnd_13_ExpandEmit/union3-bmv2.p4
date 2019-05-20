--- dumps/p4_16_samples/union3-bmv2.p4/pruned/union3-bmv2-BMV2::SimpleSwitchMidEnd_12_ExpandLookahead.p4	2019-05-20 17:32:36.894093000 +0200
+++ dumps/p4_16_samples/union3-bmv2.p4/pruned/union3-bmv2-BMV2::SimpleSwitchMidEnd_13_ExpandEmit.p4	2019-05-20 17:32:36.896473400 +0200
@@ -49,7 +49,10 @@ control egress(inout Headers h, inout Me
 control deparser(packet_out b, in Headers h) {
     apply {
         b.emit<Hdr1>(h.h1);
-        b.emit<U>(h.u);
+        {
+            b.emit<Hdr1>(h.u.h1);
+            b.emit<Hdr2>(h.u.h2);
+        }
         b.emit<Hdr2>(h.h2);
     }
 }
