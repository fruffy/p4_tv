--- before_pass
+++ after_pass
@@ -34,13 +34,9 @@ control deparser(packet_out b, in Header
 control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
     bool c_hasReturned;
     apply {
-        {
-            c_hasReturned = false;
-            if (!h.h.isValid()) 
-                c_hasReturned = true;
-            if (!c_hasReturned) 
-                ;
-        }
+        c_hasReturned = false;
+        if (!h.h.isValid()) 
+            c_hasReturned = true;
         sm.egress_spec = 9w0;
     }
 }