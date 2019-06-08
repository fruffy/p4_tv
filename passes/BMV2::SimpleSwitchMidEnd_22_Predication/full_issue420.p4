#include <core.p4>
#include <v1model.p4>
typedef bit<48> EthernetAddress;
header Ethernet_h {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}
struct Parsed_packet {
    Ethernet_h ethernet;
}
struct mystruct1 {
    bit<4> a;
    bit<4> b;
}
control DeparserI(packet_out packet, in Parsed_packet hdr) {
    apply {
        packet.emit<Ethernet_h>(hdr.ethernet);
    }
}
parser parserI(packet_in pkt, out Parsed_packet hdr, inout mystruct1 meta, inout standard_metadata_t stdmeta) {
    state start {
        pkt.extract<Ethernet_h>(hdr.ethernet);
        transition accept;
    }
}
control cIngress(inout Parsed_packet hdr, inout mystruct1 meta, inout standard_metadata_t stdmeta) {
    bool hasReturned_1;
    bool hasReturned_2;
    @name(".NoAction") action NoAction_0() {
    }
    @name("cIngress.foo") action foo_0(bit<16> bar) {
        hasReturned_1 = false;
        {
            bool cond;
            {
                bool pred;
                cond = bar == 16w0xf00d;
                pred = cond;
                {
                    hdr.ethernet.srcAddr = (pred ? 48w0xdeadbeeff00d : hdr.ethernet.srcAddr);
                    hasReturned_1 = (pred ? true : hasReturned_1);
                }
            }
        }
        {
            bool cond_0;
            {
                bool pred_0;
                cond_0 = !hasReturned_1;
                pred_0 = cond_0;
                hdr.ethernet.srcAddr = (pred_0 ? 48w0x215241100ff2 : hdr.ethernet.srcAddr);
            }
        }
    }
    @name("cIngress.tbl1") table tbl1 {
        key = {
        }
        actions = {
            foo_0();
            NoAction_0();
        }
        default_action = NoAction_0();
    }
    apply {
        hasReturned_2 = false;
        tbl1.apply();
        hasReturned_2 = true;
    }
}
control cEgress(inout Parsed_packet hdr, inout mystruct1 meta, inout standard_metadata_t stdmeta) {
    apply {
    }
}
control vc(inout Parsed_packet hdr, inout mystruct1 meta) {
    apply {
    }
}
control uc(inout Parsed_packet hdr, inout mystruct1 meta) {
    apply {
    }
}
V1Switch<Parsed_packet, mystruct1>(parserI(), vc(), cIngress(), cEgress(), uc(), DeparserI()) main;
