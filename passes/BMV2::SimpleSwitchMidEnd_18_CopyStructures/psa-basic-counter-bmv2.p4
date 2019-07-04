--- before_pass
+++ after_pass
@@ -23,12 +23,28 @@ control cIngress(inout headers_t hdr, in
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
         egress_port_1 = (PortIdUint_t)hdr.ethernet.dstAddr;
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
     @name("cIngress.counter") Counter<bit<10>, bit<12>>(32w1024, 32w0) counter_0;
     @name("cIngress.execute") action execute_1() {
