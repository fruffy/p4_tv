--- before_pass
+++ after_pass
@@ -40,7 +40,7 @@ control cIngress(inout headers_t hdr, in
     }
     apply {
         pkt_write();
-        if (istd.packet_path != PSA_PacketPath_t.RESUBMIT) 
+        if (istd.packet_path != 32w5) 
             resubmit_1();
         else 
             send_to_port();