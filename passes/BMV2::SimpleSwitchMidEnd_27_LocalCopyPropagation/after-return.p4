--- before_pass
+++ after_pass
@@ -1,13 +1,5 @@
 control ctrl() {
-    bit<32> a_0;
-    bool hasReturned;
     apply {
-        hasReturned = false;
-        a_0 = 32w0;
-        if (a_0 == 32w0) 
-            hasReturned = true;
-        else 
-            hasReturned = true;
     }
 }
 control noop();