--- dumps/pruned/bfd_offload-BMV2::SimpleSwitchMidEnd_24_ConstantFolding.p4	2019-06-08 18:31:10.906413100 +0200
+++ dumps/pruned/bfd_offload-BMV2::SimpleSwitchMidEnd_25_LocalCopyPropagation.p4	2019-06-08 18:31:10.908725000 +0200
@@ -11,15 +11,11 @@ BFD_Offload(16w32768) bfd_session_livene
     }
     bool on_tx(in bit<16> index) {
         bit<8> tmp_1;
-        bit<8> tmp_2;
-        bit<8> c;
         tmp_1 = this.getTx(index);
-        tmp_2 = tmp_1 + 8w1;
-        c = tmp_2;
-        if (c >= 8w4) 
+        if (tmp_1 + 8w1 >= 8w4) 
             return true;
         else {
-            this.setTx(index, c);
+            this.setTx(index, tmp_1 + 8w1);
             return false;
         }
     }
