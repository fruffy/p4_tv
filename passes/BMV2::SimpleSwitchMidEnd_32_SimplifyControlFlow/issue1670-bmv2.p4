--- before_pass
+++ after_pass
@@ -19,9 +19,7 @@ parser parse(packet_in pk, out parsed_pa
 control ingress(inout parsed_packet_t h, inout local_metadata_t local_metadata, inout standard_metadata_t standard_metadata) {
     apply {
         h.mirrored_md.setValid();
-        {
-            h.mirrored_md._meta_port0 = 8w0;
-        }
+        h.mirrored_md._meta_port0 = 8w0;
     }
 }
 control egress(inout parsed_packet_t hdr, inout local_metadata_t local_metadata, inout standard_metadata_t standard_metadata) {