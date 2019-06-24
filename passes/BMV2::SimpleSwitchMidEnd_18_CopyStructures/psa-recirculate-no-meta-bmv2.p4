--- before_pass
+++ after_pass
@@ -23,22 +23,54 @@ control cIngress(inout headers_t hdr, in
     psa_ingress_output_metadata_t meta_1;
     PortId_t egress_port_1;
     @name(".send_to_port") action send_to_port() {
-        meta_1 = ostd;
+        {
+            meta_1.class_of_service = ostd.class_of_service;
+            meta_1.clone = ostd.clone;
+            meta_1.clone_session_id = ostd.clone_session_id;
+            meta_1.drop = ostd.drop;
+            meta_1.resubmit = ostd.resubmit;
+            meta_1.multicast_group = ostd.multicast_group;
+            meta_1.egress_port = ostd.egress_port;
+        }
         egress_port_1 = (PortIdUint_t)hdr.ethernet.dstAddr[3:0];
         meta_1.drop = false;
         meta_1.multicast_group = 32w0;
         meta_1.egress_port = egress_port_1;
-        ostd = meta_1;
+        {
+            ostd.class_of_service = meta_1.class_of_service;
+            ostd.clone = meta_1.clone;
+            ostd.clone_session_id = meta_1.clone_session_id;
+            ostd.drop = meta_1.drop;
+            ostd.resubmit = meta_1.resubmit;
+            ostd.multicast_group = meta_1.multicast_group;
+            ostd.egress_port = meta_1.egress_port;
+        }
     }
     psa_ingress_output_metadata_t meta_2;
     PortId_t egress_port_2;
     @name(".send_to_port") action send_to_port_0() {
-        meta_2 = ostd;
+        {
+            meta_2.class_of_service = ostd.class_of_service;
+            meta_2.clone = ostd.clone;
+            meta_2.clone_session_id = ostd.clone_session_id;
+            meta_2.drop = ostd.drop;
+            meta_2.resubmit = ostd.resubmit;
+            meta_2.multicast_group = ostd.multicast_group;
+            meta_2.egress_port = ostd.egress_port;
+        }
         egress_port_2 = 32w0xfffffffa;
         meta_2.drop = false;
         meta_2.multicast_group = 32w0;
         meta_2.egress_port = egress_port_2;
-        ostd = meta_2;
+        {
+            ostd.class_of_service = meta_2.class_of_service;
+            ostd.clone = meta_2.clone;
+            ostd.clone_session_id = meta_2.clone_session_id;
+            ostd.drop = meta_2.drop;
+            ostd.resubmit = meta_2.resubmit;
+            ostd.multicast_group = meta_2.multicast_group;
+            ostd.egress_port = meta_2.egress_port;
+        }
     }
     apply {
         if (hdr.ethernet.dstAddr[3:0] >= 4w4) 