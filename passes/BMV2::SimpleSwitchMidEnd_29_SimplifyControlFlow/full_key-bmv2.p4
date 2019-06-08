#include <core.p4>
#include <v1model.p4>
header hdr {
    bit<32> a;
    bit<32> b;
}
struct Headers {
    hdr h;
}
struct Meta {
}
parser p(packet_in b, out Headers h, inout Meta m, inout standard_metadata_t sm) {
    state start {
        b.extract<hdr>(h.h);
        transition accept;
    }
}
control vrfy(inout Headers h, inout Meta m) {
    apply {
    }
}
control update(inout Headers h, inout Meta m) {
    apply {
    }
}
control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}
control deparser(packet_out b, in Headers h) {
    apply {
        b.emit<hdr>(h.h);
    }
}
control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    bit<32> key_0;
    @name(".NoAction") action NoAction_0() {
    }
    @name("ingress.c.a") action c_a() {
        h.h.b = h.h.a;
    }
    @name("ingress.c.t") table c_t_0 {
        key = {
            key_0: exact @name("e") ;
        }
        actions = {
            c_a();
            NoAction_0();
        }
        default_action = NoAction_0();
    }
    apply {
        key_0 = h.h.a + h.h.a;
        c_t_0.apply();
        sm.egress_spec = 9w0;
    }
}
V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;
