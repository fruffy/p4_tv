--- before_pass
+++ after_pass
@@ -11,9 +11,9 @@ parser ParserImpl(packet_in packet, out
     }
 }
 control IngressImpl(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
+    bit<1> registerData_0;
     @name(".NoAction") action NoAction_0() {
     }
-    bit<1> registerData_0;
     @name("IngressImpl.testRegister") register<bit<1>>(32w1) testRegister_0;
     @name("IngressImpl.drop") action drop_1() {
         mark_to_drop(standard_metadata);