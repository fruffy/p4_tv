--- before_pass
+++ after_pass
@@ -1,10 +1,14 @@
 struct T {
     bit<1> f;
 }
+struct tuple_0 {
+    T field;
+    T field_0;
+}
 struct S {
-    tuple<T, T> f1;
-    T           f2;
-    bit<1>      z;
+    tuple_0 f1;
+    T       f2;
+    bit<1>  z;
 }
 extern void f<D>(in D data);
 control c(inout bit<1> r) {
@@ -12,7 +16,7 @@ control c(inout bit<1> r) {
     bit<1> tmp_0;
     apply {
         s = S {f1 = { T {f = 1w0}, T {f = 1w1} },f2 = T {f = 1w0},z = 1w1};
-        f<tuple<T, T>>(s.f1);
+        f<tuple_0>(s.f1);
         tmp_0 = s.f2.f & s.z;
         r = tmp_0;
     }
