--- dumps/p4_16_samples/issue1607-bmv2.p4/pruned/issue1607-bmv2-BMV2::SimpleSwitchMidEnd_12_ExpandLookahead.p4	2019-05-20 17:30:23.072231400 +0200
+++ dumps/p4_16_samples/issue1607-bmv2.p4/pruned/issue1607-bmv2-BMV2::SimpleSwitchMidEnd_13_ExpandEmit.p4	2019-05-20 17:30:23.075806500 +0200
@@ -35,7 +35,108 @@ control MyComputeChecksum(inout headers
 }
 control MyDeparser(packet_out packet, in headers hdr) {
     apply {
-        packet.emit<elem[100]>(hdr.stack);
+        {
+            packet.emit<elem>(hdr.stack[0]);
+            packet.emit<elem>(hdr.stack[1]);
+            packet.emit<elem>(hdr.stack[2]);
+            packet.emit<elem>(hdr.stack[3]);
+            packet.emit<elem>(hdr.stack[4]);
+            packet.emit<elem>(hdr.stack[5]);
+            packet.emit<elem>(hdr.stack[6]);
+            packet.emit<elem>(hdr.stack[7]);
+            packet.emit<elem>(hdr.stack[8]);
+            packet.emit<elem>(hdr.stack[9]);
+            packet.emit<elem>(hdr.stack[10]);
+            packet.emit<elem>(hdr.stack[11]);
+            packet.emit<elem>(hdr.stack[12]);
+            packet.emit<elem>(hdr.stack[13]);
+            packet.emit<elem>(hdr.stack[14]);
+            packet.emit<elem>(hdr.stack[15]);
+            packet.emit<elem>(hdr.stack[16]);
+            packet.emit<elem>(hdr.stack[17]);
+            packet.emit<elem>(hdr.stack[18]);
+            packet.emit<elem>(hdr.stack[19]);
+            packet.emit<elem>(hdr.stack[20]);
+            packet.emit<elem>(hdr.stack[21]);
+            packet.emit<elem>(hdr.stack[22]);
+            packet.emit<elem>(hdr.stack[23]);
+            packet.emit<elem>(hdr.stack[24]);
+            packet.emit<elem>(hdr.stack[25]);
+            packet.emit<elem>(hdr.stack[26]);
+            packet.emit<elem>(hdr.stack[27]);
+            packet.emit<elem>(hdr.stack[28]);
+            packet.emit<elem>(hdr.stack[29]);
+            packet.emit<elem>(hdr.stack[30]);
+            packet.emit<elem>(hdr.stack[31]);
+            packet.emit<elem>(hdr.stack[32]);
+            packet.emit<elem>(hdr.stack[33]);
+            packet.emit<elem>(hdr.stack[34]);
+            packet.emit<elem>(hdr.stack[35]);
+            packet.emit<elem>(hdr.stack[36]);
+            packet.emit<elem>(hdr.stack[37]);
+            packet.emit<elem>(hdr.stack[38]);
+            packet.emit<elem>(hdr.stack[39]);
+            packet.emit<elem>(hdr.stack[40]);
+            packet.emit<elem>(hdr.stack[41]);
+            packet.emit<elem>(hdr.stack[42]);
+            packet.emit<elem>(hdr.stack[43]);
+            packet.emit<elem>(hdr.stack[44]);
+            packet.emit<elem>(hdr.stack[45]);
+            packet.emit<elem>(hdr.stack[46]);
+            packet.emit<elem>(hdr.stack[47]);
+            packet.emit<elem>(hdr.stack[48]);
+            packet.emit<elem>(hdr.stack[49]);
+            packet.emit<elem>(hdr.stack[50]);
+            packet.emit<elem>(hdr.stack[51]);
+            packet.emit<elem>(hdr.stack[52]);
+            packet.emit<elem>(hdr.stack[53]);
+            packet.emit<elem>(hdr.stack[54]);
+            packet.emit<elem>(hdr.stack[55]);
+            packet.emit<elem>(hdr.stack[56]);
+            packet.emit<elem>(hdr.stack[57]);
+            packet.emit<elem>(hdr.stack[58]);
+            packet.emit<elem>(hdr.stack[59]);
+            packet.emit<elem>(hdr.stack[60]);
+            packet.emit<elem>(hdr.stack[61]);
+            packet.emit<elem>(hdr.stack[62]);
+            packet.emit<elem>(hdr.stack[63]);
+            packet.emit<elem>(hdr.stack[64]);
+            packet.emit<elem>(hdr.stack[65]);
+            packet.emit<elem>(hdr.stack[66]);
+            packet.emit<elem>(hdr.stack[67]);
+            packet.emit<elem>(hdr.stack[68]);
+            packet.emit<elem>(hdr.stack[69]);
+            packet.emit<elem>(hdr.stack[70]);
+            packet.emit<elem>(hdr.stack[71]);
+            packet.emit<elem>(hdr.stack[72]);
+            packet.emit<elem>(hdr.stack[73]);
+            packet.emit<elem>(hdr.stack[74]);
+            packet.emit<elem>(hdr.stack[75]);
+            packet.emit<elem>(hdr.stack[76]);
+            packet.emit<elem>(hdr.stack[77]);
+            packet.emit<elem>(hdr.stack[78]);
+            packet.emit<elem>(hdr.stack[79]);
+            packet.emit<elem>(hdr.stack[80]);
+            packet.emit<elem>(hdr.stack[81]);
+            packet.emit<elem>(hdr.stack[82]);
+            packet.emit<elem>(hdr.stack[83]);
+            packet.emit<elem>(hdr.stack[84]);
+            packet.emit<elem>(hdr.stack[85]);
+            packet.emit<elem>(hdr.stack[86]);
+            packet.emit<elem>(hdr.stack[87]);
+            packet.emit<elem>(hdr.stack[88]);
+            packet.emit<elem>(hdr.stack[89]);
+            packet.emit<elem>(hdr.stack[90]);
+            packet.emit<elem>(hdr.stack[91]);
+            packet.emit<elem>(hdr.stack[92]);
+            packet.emit<elem>(hdr.stack[93]);
+            packet.emit<elem>(hdr.stack[94]);
+            packet.emit<elem>(hdr.stack[95]);
+            packet.emit<elem>(hdr.stack[96]);
+            packet.emit<elem>(hdr.stack[97]);
+            packet.emit<elem>(hdr.stack[98]);
+            packet.emit<elem>(hdr.stack[99]);
+        }
     }
 }
 V1Switch<headers, metadata>(MyParser(), MyVerifyChecksum(), MyIngress(), MyEgress(), MyComputeChecksum(), MyDeparser()) main;
