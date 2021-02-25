#include <core.p4>


header H {
    bit<32>  a;
    bit<32>  b;
}

struct Headers {
    H     h;
    H     h1;
}

parser p(packet_in pkt, out Headers hdr) {
    state start {
        transition parse_hdrs;
    }
    state parse_hdrs {
        transition accept;
    }
}

control ingress(inout Headers h) {

    action simple_action(inout bit<32> val) {
        val = 32w2;
    }

    apply {
        if (h.h.b == 32w1) {
            h.h.a = 32w1;
            simple_action(h.h.a);
        } else {
            h.h.b = 32w2;
        }
    }
}

parser Parser(packet_in b, out Headers hdr);
control Ingress(inout Headers hdr);
package top(Parser p, Ingress ig);
top(p(), ingress()) main;

