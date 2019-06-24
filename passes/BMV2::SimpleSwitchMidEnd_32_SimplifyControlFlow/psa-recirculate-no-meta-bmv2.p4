--- before_pass
+++ after_pass
@@ -21,18 +21,14 @@ parser IngressParserImpl(packet_in pkt,
 }
 control cIngress(inout headers_t hdr, inout metadata_t user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
     @name(".send_to_port") action send_to_port() {
-        {
-            ostd.drop = false;
-            ostd.multicast_group = 32w0;
-            ostd.egress_port = (PortIdUint_t)hdr.ethernet.dstAddr[3:0];
-        }
+        ostd.drop = false;
+        ostd.multicast_group = 32w0;
+        ostd.egress_port = (PortIdUint_t)hdr.ethernet.dstAddr[3:0];
     }
     @name(".send_to_port") action send_to_port_0() {
-        {
-            ostd.drop = false;
-            ostd.multicast_group = 32w0;
-            ostd.egress_port = 32w0xfffffffa;
-        }
+        ostd.drop = false;
+        ostd.multicast_group = 32w0;
+        ostd.egress_port = 32w0xfffffffa;
     }
     apply {
         if (hdr.ethernet.dstAddr[3:0] >= 4w4) 