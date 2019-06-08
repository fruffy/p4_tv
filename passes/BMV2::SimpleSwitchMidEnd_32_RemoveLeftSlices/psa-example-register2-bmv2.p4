--- dumps/pruned/psa-example-register2-bmv2-BMV2::SimpleSwitchMidEnd_31_TableHit.p4	2019-06-08 18:33:18.683347800 +0200
+++ dumps/pruned/psa-example-register2-bmv2-BMV2::SimpleSwitchMidEnd_32_RemoveLeftSlices.p4	2019-06-08 18:33:18.686330200 +0200
@@ -51,8 +51,8 @@ control ingress(inout headers hdr, inout
     PacketByteCountState_t s;
     @name(".update_pkt_ip_byte_count") action update_pkt_ip_byte_count() {
         s = tmp_1;
-        s[79:48] = tmp_1[79:48] + 32w1;
-        s[47:0] = s[47:0] + (bit<48>)hdr.ipv4.totalLen;
+        s = s & ~80w0xffffffff000000000000 | (bit<80>)(tmp_1[79:48] + 32w1) << 48 & 80w0xffffffff000000000000;
+        s = s & ~80w0xffffffffffff | (bit<80>)(s[47:0] + (bit<48>)hdr.ipv4.totalLen) << 0 & 80w0xffffffffffff;
         tmp_1 = s;
     }
     @name("ingress.port_pkt_ip_bytes_in") Register<PacketByteCountState_t, PortId_t>(32w512) port_pkt_ip_bytes_in;
