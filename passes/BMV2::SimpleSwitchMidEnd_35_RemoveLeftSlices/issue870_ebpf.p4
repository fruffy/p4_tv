--- before_pass
+++ after_pass
@@ -44,7 +44,7 @@ control pipe(inout Headers_t headers, ou
     }
     @name("pipe.Reject") action Reject(IPv4Address add) {
         pass = false;
-        headers.ipv4.srcAddr[31:0] = add[31:16] ++ add[15:0];
+        headers.ipv4.srcAddr = headers.ipv4.srcAddr & ~32w0xffffffff | (bit<32>)(add[31:16] ++ add[15:0]) << 0 & 32w0xffffffff;
     }
     @name("pipe.Check_src_ip") table Check_src_ip_0 {
         key = {