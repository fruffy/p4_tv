--- dumps/pruned/union-valid-bmv2-BMV2::SimpleSwitchMidEnd_7_TypeChecking.p4	2019-06-08 18:34:21.245617800 +0200
+++ dumps/pruned/union-valid-bmv2-BMV2::SimpleSwitchMidEnd_8_SimplifyKey.p4	2019-06-08 18:34:21.250298800 +0200
@@ -50,9 +50,10 @@ control deparser(packet_out b, in Header
 control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
     @name("ingress.a") action a_0() {
     }
+    bool key_0;
     @name("ingress.t") table t {
         key = {
-            h.u.isValid(): exact @name("h.u.$valid$") ;
+            key_0: exact @name("h.u.$valid$") ;
         }
         actions = {
             a_0();
@@ -60,7 +61,10 @@ control ingress(inout Headers h, inout M
         default_action = a_0();
     }
     apply {
-        t.apply();
+        {
+            key_0 = h.u.isValid();
+            t.apply();
+        }
     }
 }
 V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;
