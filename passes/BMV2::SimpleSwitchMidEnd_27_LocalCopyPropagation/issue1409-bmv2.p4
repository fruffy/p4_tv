--- before_pass
+++ after_pass
@@ -9,11 +9,9 @@ struct headers_t {
 struct metadata_t {
 }
 parser TestParser(packet_in b, out headers_t headers, inout metadata_t meta, inout standard_metadata_t standard_metadata) {
-    bit<32> test_f_0;
     state start {
         b.extract<test_header_t>(headers.test.next);
-        test_f_0 = headers.test.lastIndex << 1;
-        transition select(test_f_0) {
+        transition select(headers.test.lastIndex << 1) {
             32w0: f;
             default: a;
         }