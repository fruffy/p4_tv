--- before_pass
+++ after_pass
@@ -24,10 +24,10 @@ control c(out bit<1> x) {
             if (!h1_0.isValid() && !h2_0.isValid() || h1_0.isValid() && h2_0.isValid() && h1_0.a == h2_0.a && h1_0.b == h2_0.b) 
                 x = 1w1;
             else 
-                if (true && s1_0_a == s2_0_a && (!s1_0_h.isValid() && !s2_0_h.isValid() || s1_0_h.isValid() && s2_0_h.isValid() && s1_0_h.a == s2_0_h.a && s1_0_h.b == s2_0_h.b)) 
+                if (s1_0_a == s2_0_a && (!s1_0_h.isValid() && !s2_0_h.isValid() || s1_0_h.isValid() && s2_0_h.isValid() && s1_0_h.a == s2_0_h.a && s1_0_h.b == s2_0_h.b)) 
                     x = 1w1;
                 else 
-                    if (true && (!a1_0[0].isValid() && !a2_0[0].isValid() || a1_0[0].isValid() && a2_0[0].isValid() && a1_0[0].a == a2_0[0].a && a1_0[0].b == a2_0[0].b) && (!a1_0[1].isValid() && !a2_0[1].isValid() || a1_0[1].isValid() && a2_0[1].isValid() && a1_0[1].a == a2_0[1].a && a1_0[1].b == a2_0[1].b)) 
+                    if ((!a1_0[0].isValid() && !a2_0[0].isValid() || a1_0[0].isValid() && a2_0[0].isValid() && a1_0[0].a == a2_0[0].a && a1_0[0].b == a2_0[0].b) && (!a1_0[1].isValid() && !a2_0[1].isValid() || a1_0[1].isValid() && a2_0[1].isValid() && a1_0[1].a == a2_0[1].a && a1_0[1].b == a2_0[1].b)) 
                         x = 1w1;
                     else 
                         x = 1w0;