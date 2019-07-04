#include <core.p4>
#include <psa.p4>
typedef bit<48> EthernetAddress;
header ethernet_t {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}
struct empty_metadata_t {
}
struct metadata_t {
}
struct headers_t {
    ethernet_t ethernet;
}
parser IngressParserImpl(packet_in pkt, out headers_t hdr, inout metadata_t user_meta, in psa_ingress_parser_input_metadata_t istd, in empty_metadata_t resubmit_meta, in empty_metadata_t recirculate_meta) {
    state start {
        pkt.extract<ethernet_t>(hdr.ethernet);
        transition accept;
    }
}
control cIngress(inout headers_t hdr, inout metadata_t user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
    psa_ingress_output_metadata_t meta_1;
    PortId_t egress_port_1;
    psa_ingress_output_metadata_t meta_2;
    PortId_t egress_port_2;
    @name(".send_to_port") action send_to_port() {
        {
            meta_1.class_of_service = ostd.class_of_service;
            meta_1.clone = ostd.clone;
            meta_1.clone_session_id = ostd.clone_session_id;
            meta_1.drop = ostd.drop;
            meta_1.resubmit = ostd.resubmit;
            meta_1.multicast_group = ostd.multicast_group;
            meta_1.egress_port = ostd.egress_port;
        }
        egress_port_1 = (PortIdUint_t)hdr.ethernet.dstAddr;
        meta_1.drop = false;
        meta_1.multicast_group = 32w0;
        meta_1.egress_port = egress_port_1;
        {
            ostd.class_of_service = meta_1.class_of_service;
            ostd.clone = meta_1.clone;
            ostd.clone_session_id = meta_1.clone_session_id;
            ostd.drop = meta_1.drop;
            ostd.resubmit = meta_1.resubmit;
            ostd.multicast_group = meta_1.multicast_group;
            ostd.egress_port = meta_1.egress_port;
        }
    }
    @name(".send_to_port") action send_to_port_0() {
        {
            meta_2.class_of_service = ostd.class_of_service;
            meta_2.clone = ostd.clone;
            meta_2.clone_session_id = ostd.clone_session_id;
            meta_2.drop = ostd.drop;
            meta_2.resubmit = ostd.resubmit;
            meta_2.multicast_group = ostd.multicast_group;
            meta_2.egress_port = ostd.egress_port;
        }
        egress_port_2 = 32w0xfffffffa;
        meta_2.drop = false;
        meta_2.multicast_group = 32w0;
        meta_2.egress_port = egress_port_2;
        {
            ostd.class_of_service = meta_2.class_of_service;
            ostd.clone = meta_2.clone;
            ostd.clone_session_id = meta_2.clone_session_id;
            ostd.drop = meta_2.drop;
            ostd.resubmit = meta_2.resubmit;
            ostd.multicast_group = meta_2.multicast_group;
            ostd.egress_port = meta_2.egress_port;
        }
    }
    apply {
        if (hdr.ethernet.dstAddr[3:0] >= 4w4) 
            send_to_port();
        else 
            send_to_port_0();
    }
}
parser EgressParserImpl(packet_in buffer, out headers_t hdr, inout metadata_t user_meta, in psa_egress_parser_input_metadata_t istd, in empty_metadata_t normal_meta, in empty_metadata_t clone_i2e_meta, in empty_metadata_t clone_e2e_meta) {
    state start {
        buffer.extract<ethernet_t>(hdr.ethernet);
        transition accept;
    }
}
control cEgress(inout headers_t hdr, inout metadata_t user_meta, in psa_egress_input_metadata_t istd, inout psa_egress_output_metadata_t ostd) {
    @name("cEgress.add") action add_1() {
        hdr.ethernet.dstAddr = hdr.ethernet.dstAddr + hdr.ethernet.srcAddr;
    }
    @name("cEgress.e") table e_0 {
        actions = {
            add_1();
        }
        default_action = add_1();
    }
    apply {
        e_0.apply();
    }
}
control IngressDeparserImpl(packet_out buffer, out empty_metadata_t clone_i2e_meta, out empty_metadata_t resubmit_meta, out empty_metadata_t normal_meta, inout headers_t hdr, in metadata_t meta, in psa_ingress_output_metadata_t istd) {
    apply {
        buffer.emit<ethernet_t>(hdr.ethernet);
    }
}
control EgressDeparserImpl(packet_out buffer, out empty_metadata_t clone_e2e_meta, out empty_metadata_t recirculate_meta, inout headers_t hdr, in metadata_t meta, in psa_egress_output_metadata_t istd, in psa_egress_deparser_input_metadata_t edstd) {
    apply {
        buffer.emit<ethernet_t>(hdr.ethernet);
    }
}
IngressPipeline<headers_t, metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(IngressParserImpl(), cIngress(), IngressDeparserImpl()) ip;
EgressPipeline<headers_t, metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(EgressParserImpl(), cEgress(), EgressDeparserImpl()) ep;
PSA_Switch<headers_t, metadata_t, headers_t, metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(ip, PacketReplicationEngine(), ep, BufferingQueueingEngine()) main;
