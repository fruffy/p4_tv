--- dumps/pruned/psa-multicast-basic-corrected-bmv2-BMV2::SimpleSwitchMidEnd_24_ConstantFolding.p4	2019-06-08 18:33:25.210321000 +0200
+++ dumps/pruned/psa-multicast-basic-corrected-bmv2-BMV2::SimpleSwitchMidEnd_25_LocalCopyPropagation.p4	2019-06-08 18:33:25.255052000 +0200
@@ -20,29 +20,12 @@ parser IngressParserImpl(packet_in pkt,
     }
 }
 control cIngress(inout headers_t hdr, inout metadata_t user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
-    psa_ingress_output_metadata_t meta_1;
-    MulticastGroup_t multicast_group_1;
     @name(".multicast") action multicast() {
         {
-            meta_1.class_of_service = ostd.class_of_service;
-            meta_1.clone = ostd.clone;
-            meta_1.clone_session_id = ostd.clone_session_id;
-            meta_1.drop = ostd.drop;
-            meta_1.resubmit = ostd.resubmit;
-            meta_1.multicast_group = ostd.multicast_group;
-            meta_1.egress_port = ostd.egress_port;
         }
-        multicast_group_1 = (MulticastGroup_t)hdr.ethernet.dstAddr[31:0];
-        meta_1.drop = false;
-        meta_1.multicast_group = multicast_group_1;
         {
-            ostd.class_of_service = meta_1.class_of_service;
-            ostd.clone = meta_1.clone;
-            ostd.clone_session_id = meta_1.clone_session_id;
-            ostd.drop = meta_1.drop;
-            ostd.resubmit = meta_1.resubmit;
-            ostd.multicast_group = meta_1.multicast_group;
-            ostd.egress_port = meta_1.egress_port;
+            ostd.drop = false;
+            ostd.multicast_group = (MulticastGroup_t)hdr.ethernet.dstAddr[31:0];
         }
     }
     apply {
