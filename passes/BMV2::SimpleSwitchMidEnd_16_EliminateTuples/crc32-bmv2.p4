--- before_pass
+++ after_pass
@@ -64,6 +64,9 @@ control MyVerifyChecksum(inout headers h
     apply {
     }
 }
+struct tuple_0 {
+    bit<32> field;
+}
 control MyIngress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
     bit<48> tmp_2;
     bit<32> nbase_0;
@@ -109,7 +112,7 @@ control MyIngress(inout headers hdr, ino
         nbase_0 = hdr.p4calc.operand_b;
         ncount_0 = 64w8589934592;
         ninput_0 = hdr.p4calc.operand_a;
-        hash<bit<32>, bit<32>, tuple<bit<32>>, bit<64>>(nselect_0, HashAlgorithm.crc32, nbase_0, { ninput_0 }, ncount_0);
+        hash<bit<32>, bit<32>, tuple_0, bit<64>>(nselect_0, HashAlgorithm.crc32, nbase_0, { ninput_0 }, ncount_0);
         hdr.p4calc.res = nselect_0;
         tmp_2 = hdr.ethernet.dstAddr;
         hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
@@ -158,7 +161,7 @@ control MyEgress(inout headers hdr, inou
 }
 control MyComputeChecksum(inout headers hdr, inout metadata meta) {
     apply {
-        update_checksum<tuple<bit<32>>, bit<32>>(hdr.p4calc.isValid(), { hdr.p4calc.operand_a }, hdr.p4calc.res, HashAlgorithm.crc32);
+        update_checksum<tuple_0, bit<32>>(hdr.p4calc.isValid(), { hdr.p4calc.operand_a }, hdr.p4calc.res, HashAlgorithm.crc32);
     }
 }
 control MyDeparser(packet_out packet, in headers hdr) {