--- before_pass
+++ after_pass
@@ -22,7 +22,7 @@ parser ingressParserImpl(packet_in packe
 control ingressImpl(inout headers_t hdr, inout metadata_t meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
     apply {
         ostd.drop = false;
-        ostd.egress_port = (PortId_t)32w3;
+        ostd.egress_port = 32w3;
     }
 }
 parser egressParserImpl(packet_in packet, out headers_t hdr, inout metadata_t meta, in psa_egress_parser_input_metadata_t istd, in empty_metadata_t normal_meta, in empty_metadata_t clone_i2e_meta, in empty_metadata_t clone_e2e_meta) {
