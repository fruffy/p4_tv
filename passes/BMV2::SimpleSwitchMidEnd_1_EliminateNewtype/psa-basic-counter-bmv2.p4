--- before_pass
+++ after_pass
@@ -22,7 +22,7 @@ parser IngressParserImpl(packet_in pkt,
 control cIngress(inout headers_t hdr, inout metadata_t user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
     @name(".send_to_port") action send_to_port(inout psa_ingress_output_metadata_t meta_1, in PortId_t egress_port_1) {
         meta_1.drop = false;
-        meta_1.multicast_group = (MulticastGroup_t)32w0;
+        meta_1.multicast_group = 32w0;
         meta_1.egress_port = egress_port_1;
     }
     @name("cIngress.counter") Counter<bit<10>, bit<12>>(32w1024, PSA_CounterType_t.PACKETS) counter_0;
@@ -36,7 +36,7 @@ control cIngress(inout headers_t hdr, in
         default_action = execute_1();
     }
     apply {
-        send_to_port(ostd, (PortId_t)(PortIdUint_t)hdr.ethernet.dstAddr[1:0]);
+        send_to_port(ostd, (PortIdUint_t)hdr.ethernet.dstAddr[1:0]);
         tbl_0.apply();
     }
 }