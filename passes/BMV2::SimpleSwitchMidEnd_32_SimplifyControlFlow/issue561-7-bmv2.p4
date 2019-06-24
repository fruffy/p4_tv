--- before_pass
+++ after_pass
@@ -66,11 +66,9 @@ control egress(inout headers hdr, inout
 }
 control DeparserImpl(packet_out packet, in headers hdr) {
     apply {
-        {
-            packet.emit<S>(hdr.base);
-            packet.emit<O1>(hdr.u[0].byte);
-            packet.emit<O2>(hdr.u[0].short);
-        }
+        packet.emit<S>(hdr.base);
+        packet.emit<O1>(hdr.u[0].byte);
+        packet.emit<O2>(hdr.u[0].short);
     }
 }
 control verifyChecksum(inout headers hdr, inout metadata meta) {