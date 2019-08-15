--- before_pass
+++ after_pass
@@ -28,7 +28,7 @@ control ingress_impl(inout headers_t hdr
 }
 control egress_impl(inout headers_t hdr, inout local_metadata_t local_metadata, inout standard_metadata_t standard_metadata) {
     apply {
-        local_metadata.m16 = (16w0 ++ local_metadata.f16)[14:0] ++ 1w0;
+        local_metadata.m16 = local_metadata.f16[14:0] ++ 1w0;
         local_metadata.d16 = 1w0 ++ local_metadata.f16[15:1];
         local_metadata.a16 = (int<16>)(16s0 ++ local_metadata.x16 << 1)[15:0];
         local_metadata.b16 = (int<16>)(16s0 ++ local_metadata.x16 >> 1)[15:0];