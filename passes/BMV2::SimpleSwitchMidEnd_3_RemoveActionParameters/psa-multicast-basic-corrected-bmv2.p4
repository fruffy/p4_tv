--- before_pass
+++ after_pass
@@ -20,12 +20,17 @@ parser IngressParserImpl(packet_in pkt,
     }
 }
 control cIngress(inout headers_t hdr, inout metadata_t user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
-    @name(".multicast") action multicast(inout psa_ingress_output_metadata_t meta_1, in MulticastGroup_t multicast_group_1) {
+    psa_ingress_output_metadata_t meta_1;
+    MulticastGroup_t multicast_group_1;
+    @name(".multicast") action multicast() {
+        meta_1 = ostd;
+        multicast_group_1 = (MulticastGroupUint_t)hdr.ethernet.dstAddr;
         meta_1.drop = false;
         meta_1.multicast_group = multicast_group_1;
+        ostd = meta_1;
     }
     apply {
-        multicast(ostd, (MulticastGroupUint_t)hdr.ethernet.dstAddr);
+        multicast();
     }
 }
 parser EgressParserImpl(packet_in buffer, out headers_t hdr, inout metadata_t user_meta, in psa_egress_parser_input_metadata_t istd, in empty_metadata_t normal_meta, in empty_metadata_t clone_i2e_meta, in empty_metadata_t clone_e2e_meta) {
