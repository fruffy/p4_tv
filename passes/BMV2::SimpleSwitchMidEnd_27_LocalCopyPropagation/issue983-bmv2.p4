--- before_pass
+++ after_pass
@@ -40,9 +40,6 @@ parser IngressParserImpl(packet_in buffe
     }
 }
 control ingress(inout headers hdr, inout metadata user_meta, inout standard_metadata_t standard_metadata) {
-    bit<16> tmp_0;
-    bit<32> x1_0;
-    bit<16> x2_0;
     @name(".NoAction") action NoAction_0() {
     }
     @name("ingress.debug_table_cksum1") table debug_table_cksum1_0 {
@@ -67,12 +64,9 @@ control ingress(inout headers hdr, inout
         default_action = NoAction_0();
     }
     apply {
-        tmp_0 = ~hdr.ethernet.etherType;
-        x1_0 = (bit<32>)tmp_0;
-        x2_0 = x1_0[31:16] + x1_0[15:0];
-        user_meta._fwd_meta_tmp0 = tmp_0;
-        user_meta._fwd_meta_x11 = x1_0;
-        user_meta._fwd_meta_x22 = x2_0;
+        user_meta._fwd_meta_tmp0 = ~hdr.ethernet.etherType;
+        user_meta._fwd_meta_x11 = (bit<32>)~hdr.ethernet.etherType;
+        user_meta._fwd_meta_x22 = ((bit<32>)~hdr.ethernet.etherType)[31:16] + ((bit<32>)~hdr.ethernet.etherType)[15:0];
         user_meta._fwd_meta_x33 = (bit<32>)~hdr.ethernet.etherType;
         user_meta._fwd_meta_x44 = ~(bit<32>)hdr.ethernet.etherType;
         user_meta._fwd_meta_exp_etherType5 = 16w0x800;
@@ -81,15 +75,15 @@ control ingress(inout headers hdr, inout
         user_meta._fwd_meta_exp_x38 = 32w0xf7ff;
         user_meta._fwd_meta_exp_x49 = 32w0xfffff7ff;
         hdr.ethernet.dstAddr = 48w0;
-        if (hdr.ethernet.etherType != user_meta._fwd_meta_exp_etherType5) 
+        if (hdr.ethernet.etherType != 16w0x800) 
             hdr.ethernet.dstAddr[47:40] = 8w1;
-        if (user_meta._fwd_meta_x11 != user_meta._fwd_meta_exp_x16) 
+        if ((bit<32>)~hdr.ethernet.etherType != 32w0xf7ff) 
             hdr.ethernet.dstAddr[39:32] = 8w1;
-        if (user_meta._fwd_meta_x22 != user_meta._fwd_meta_exp_x27) 
+        if (((bit<32>)~hdr.ethernet.etherType)[31:16] + ((bit<32>)~hdr.ethernet.etherType)[15:0] != 16w0xf7ff) 
             hdr.ethernet.dstAddr[31:24] = 8w1;
-        if (user_meta._fwd_meta_x33 != user_meta._fwd_meta_exp_x38) 
+        if ((bit<32>)~hdr.ethernet.etherType != 32w0xf7ff) 
             hdr.ethernet.dstAddr[23:16] = 8w1;
-        if (user_meta._fwd_meta_x44 != user_meta._fwd_meta_exp_x49) 
+        if (~(bit<32>)hdr.ethernet.etherType != 32w0xfffff7ff) 
             hdr.ethernet.dstAddr[15:8] = 8w1;
         debug_table_cksum1_0.apply();
     }