--- dumps/p4_16_samples/issue841.p4/pruned/issue841-BMV2::SimpleSwitchMidEnd_28_ValidateTableProperties.p4	2019-05-20 17:31:08.030364300 +0200
+++ dumps/p4_16_samples/issue841.p4/pruned/issue841-BMV2::SimpleSwitchMidEnd_29_SimplifyControlFlow.p4	2019-05-20 17:31:08.084202200 +0200
@@ -38,11 +38,9 @@ control MyComputeChecksum(inout headers
     @name("MyComputeChecksum.checksum") Checksum16() checksum;
     apply {
         h_1.setValid();
-        {
-            h_1.src = hdr.h.src;
-            h_1.dst = hdr.h.dst;
-            h_1.csum = 16w0;
-        }
+        h_1.src = hdr.h.src;
+        h_1.dst = hdr.h.dst;
+        h_1.csum = 16w0;
         tmp_0 = checksum.get<h_t>(h_1);
         hdr.h.csum = tmp_0;
     }
