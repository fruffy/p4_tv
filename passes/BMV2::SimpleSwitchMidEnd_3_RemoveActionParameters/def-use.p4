--- dumps/p4_16_samples/def-use.p4/pruned/def-use-BMV2::SimpleSwitchMidEnd_2_EliminateSerEnums.p4	2019-05-20 17:29:30.820486200 +0200
+++ dumps/p4_16_samples/def-use.p4/pruned/def-use-BMV2::SimpleSwitchMidEnd_3_RemoveActionParameters.p4	2019-05-20 17:29:30.865121800 +0200
@@ -15,6 +15,7 @@ control IngressI(inout H hdr, inout M me
     }
 }
 control EgressI(inout H hdr, inout M meta, inout std_meta_t std_meta) {
+    bool hasReturned_0;
     @name("EgressI.a") action a_0() {
     }
     @name("EgressI.t") table t {
@@ -26,7 +27,7 @@ control EgressI(inout H hdr, inout M met
         default_action = a_0();
     }
     apply {
-        bool hasReturned_0 = false;
+        hasReturned_0 = false;
         switch (t.apply().action_run) {
             a_0: {
                 hasReturned_0 = true;
