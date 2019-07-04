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
    MulticastGroup_t multicast_group_1;
    @name(".multicast") action multicast() {
        {
            meta_1.class_of_service = ostd.class_of_service;
            meta_1.clone = ostd.clone;
            meta_1.clone_session_id = ostd.clone_session_id;
            meta_1.drop = ostd.drop;
            meta_1.resubmit = ostd.resubmit;
            meta_1.multicast_group = ostd.multicast_group;
            meta_1.egress_port = ostd.egress_port;
        }
        multicast_group_1 = (MulticastGroupUint_t)hdr.ethernet.dstAddr;
        meta_1.drop = false;
        meta_1.multicast_group = multicast_group_1;
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
    apply {
        multicast();
    }
}
parser EgressParserImpl(packet_in buffer, out headers_t hdr, inout metadata_t user_meta, in psa_egress_parser_input_metadata_t istd, in empty_metadata_t normal_meta, in empty_metadata_t clone_i2e_meta, in empty_metadata_t clone_e2e_meta) {
    state start {
        transition accept;
    }
}
control cEgress(inout headers_t hdr, inout metadata_t user_meta, in psa_egress_input_metadata_t istd, inout psa_egress_output_metadata_t ostd) {
    apply {
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
