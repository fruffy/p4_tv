--- before_pass
+++ after_pass
@@ -77,23 +77,15 @@ parser PROTParser(packet_in packet, out
         meta._addrLen2 = meta._addrLen2 + (9w64 - (meta._addrLen2 & 9w63) & 9w63);
         meta._currPos3 = (bit<8>)(9w3 + (meta._addrLen2 >> 6));
         inf_0.setInvalid();
-        {
-            meta_0_currPos = (bit<8>)(9w3 + (meta._addrLen2 >> 6));
-            {
-                meta_0_currenti.upDirection = meta._currenti_upDirection4;
-            }
-        }
+        meta_0_currPos = (bit<8>)(9w3 + (meta._addrLen2 >> 6));
+        meta_0_currenti.upDirection = meta._currenti_upDirection4;
         packet.extract<prot_i_t>(inf_0);
         meta_0_currenti.upDirection = meta._currenti_upDirection4 + (bit<1>)(hdr.prot_common.curri == (bit<8>)(9w3 + (meta._addrLen2 >> 6))) * inf_0.upDirection;
         meta_0_currPos = (bit<8>)(9w3 + (meta._addrLen2 >> 6)) + 8w1;
         hdr.prot_inf_0 = inf_0;
-        {
-            meta._hLeft1 = inf_0.segLen;
-            meta._currPos3 = meta_0_currPos;
-            {
-                meta._currenti_upDirection4 = meta_0_currenti.upDirection;
-            }
-        }
+        meta._hLeft1 = inf_0.segLen;
+        meta._currPos3 = meta_0_currPos;
+        meta._currenti_upDirection4 = meta_0_currenti.upDirection;
         transition parse_prot_h_0_pre;
     }
     state parse_prot_h_0_pre {
@@ -116,23 +108,15 @@ parser PROTParser(packet_in packet, out
     }
     state parse_prot_inf_1 {
         inf_0.setInvalid();
-        {
-            meta_0_currPos = meta._currPos3;
-            {
-                meta_0_currenti.upDirection = meta._currenti_upDirection4;
-            }
-        }
+        meta_0_currPos = meta._currPos3;
+        meta_0_currenti.upDirection = meta._currenti_upDirection4;
         packet.extract<prot_i_t>(inf_0);
         meta_0_currenti.upDirection = meta._currenti_upDirection4 + (bit<1>)(hdr.prot_common.curri == meta._currPos3) * inf_0.upDirection;
         meta_0_currPos = meta._currPos3 + 8w1;
         hdr.prot_inf_1 = inf_0;
-        {
-            meta._hLeft1 = inf_0.segLen;
-            meta._currPos3 = meta._currPos3 + 8w1;
-            {
-                meta._currenti_upDirection4 = meta_0_currenti.upDirection;
-            }
-        }
+        meta._hLeft1 = inf_0.segLen;
+        meta._currPos3 = meta._currPos3 + 8w1;
+        meta._currenti_upDirection4 = meta_0_currenti.upDirection;
         transition accept;
     }
 }
@@ -156,26 +140,24 @@ control PROTComputeChecksum(inout header
 }
 control PROTDeparser(packet_out packet, in headers hdr) {
     apply {
-        {
-            packet.emit<preamble_t>(hdr.preamble);
-            packet.emit<prot_common_t>(hdr.prot_common);
-            packet.emit<prot_addr_common_t>(hdr.prot_addr_common);
-            packet.emit<prot_host_addr_ipv4_t>(hdr.prot_host_addr_dst.ipv4);
-            packet.emit<prot_host_addr_ipv4_t>(hdr.prot_host_addr_src.ipv4);
-            packet.emit<prot_host_addr_padding_t>(hdr.prot_host_addr_padding);
-            packet.emit<prot_i_t>(hdr.prot_inf_0);
-            packet.emit<prot_h_t>(hdr.prot_h_0[0]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[1]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[2]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[3]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[4]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[5]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[6]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[7]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[8]);
-            packet.emit<prot_h_t>(hdr.prot_h_0[9]);
-            packet.emit<prot_i_t>(hdr.prot_inf_1);
-        }
+        packet.emit<preamble_t>(hdr.preamble);
+        packet.emit<prot_common_t>(hdr.prot_common);
+        packet.emit<prot_addr_common_t>(hdr.prot_addr_common);
+        packet.emit<prot_host_addr_ipv4_t>(hdr.prot_host_addr_dst.ipv4);
+        packet.emit<prot_host_addr_ipv4_t>(hdr.prot_host_addr_src.ipv4);
+        packet.emit<prot_host_addr_padding_t>(hdr.prot_host_addr_padding);
+        packet.emit<prot_i_t>(hdr.prot_inf_0);
+        packet.emit<prot_h_t>(hdr.prot_h_0[0]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[1]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[2]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[3]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[4]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[5]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[6]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[7]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[8]);
+        packet.emit<prot_h_t>(hdr.prot_h_0[9]);
+        packet.emit<prot_i_t>(hdr.prot_inf_1);
     }
 }
 V1Switch<headers, metadata>(PROTParser(), PROTVerifyChecksum(), PROTIngress(), PROTEgress(), PROTComputeChecksum(), PROTDeparser()) main;