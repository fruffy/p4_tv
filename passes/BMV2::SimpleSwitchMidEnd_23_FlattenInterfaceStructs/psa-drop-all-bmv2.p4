--- before_pass
+++ after_pass
@@ -25,7 +25,6 @@ struct empty_metadata_t {
 struct fwd_metadata_t {
 }
 struct metadata_t {
-    fwd_metadata_t fwd_metadata;
 }
 struct headers_t {
     ethernet_t ethernet;