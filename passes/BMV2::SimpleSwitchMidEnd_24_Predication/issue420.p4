--- before_pass
+++ after_pass
@@ -31,12 +31,27 @@ control cIngress(inout Parsed_packet hdr
     }
     @name("cIngress.foo") action foo(bit<16> bar) {
         hasReturned = false;
-        if (bar == 16w0xf00d) {
-            hdr.ethernet.srcAddr = 48w0xdeadbeeff00d;
-            hasReturned = true;
+        {
+            bool cond;
+            {
+                bool pred;
+                cond = bar == 16w0xf00d;
+                pred = cond;
+                {
+                    hdr.ethernet.srcAddr = (pred ? 48w0xdeadbeeff00d : hdr.ethernet.srcAddr);
+                    hasReturned = (pred ? true : hasReturned);
+                }
+            }
+        }
+        {
+            bool cond_0;
+            {
+                bool pred_0;
+                cond_0 = !hasReturned;
+                pred_0 = cond_0;
+                hdr.ethernet.srcAddr = (pred_0 ? 48w0x215241100ff2 : hdr.ethernet.srcAddr);
+            }
         }
-        if (!hasReturned) 
-            hdr.ethernet.srcAddr = 48w0x215241100ff2;
     }
     @name("cIngress.tbl1") table tbl1_0 {
         key = {