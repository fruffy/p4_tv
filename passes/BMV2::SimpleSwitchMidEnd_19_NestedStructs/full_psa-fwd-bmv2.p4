#include <core.p4>
#include <psa.p4>
typedef bit<48> EthernetAddress;
header ethernet_t {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}
struct fwd_metadata_t {
}
struct empty_t {
}
struct metadata {
    fwd_metadata_t fwd_metadata;
}
struct headers {
    ethernet_t ethernet;
}
parser IngressParserImpl(packet_in buffer, out headers parsed_hdr, inout metadata user_meta, in psa_ingress_parser_input_metadata_t istd, in empty_t resubmit_meta, in empty_t recirculate_meta) {
    ethernet_t parsed_hdr_2_ethernet;
    fwd_metadata_t user_meta_2_fwd_metadata;
    state start {
        parsed_hdr_2_ethernet.setInvalid();
        {
            {
            }
        }
        buffer.extract<ethernet_t>(parsed_hdr_2_ethernet);
        {
            parsed_hdr.ethernet = parsed_hdr_2_ethernet;
        }
        {
            {
            }
        }
        transition accept;
    }
}
parser EgressParserImpl(packet_in buffer, out headers parsed_hdr, inout metadata user_meta, in psa_egress_parser_input_metadata_t istd, in empty_t normal_meta, in empty_t clone_i2e_meta, in empty_t clone_e2e_meta) {
    ethernet_t parsed_hdr_3_ethernet;
    fwd_metadata_t user_meta_3_fwd_metadata;
    state start {
        parsed_hdr_3_ethernet.setInvalid();
        {
            {
            }
        }
        buffer.extract<ethernet_t>(parsed_hdr_3_ethernet);
        {
            parsed_hdr.ethernet = parsed_hdr_3_ethernet;
        }
        {
            {
            }
        }
        transition accept;
    }
}
control ingress(inout headers hdr, inout metadata user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
    apply {
    }
}
control egress(inout headers hdr, inout metadata user_meta, in psa_egress_input_metadata_t istd, inout psa_egress_output_metadata_t ostd) {
    apply {
    }
}
control IngressDeparserImpl(packet_out buffer, out empty_t clone_i2e_meta, out empty_t resubmit_meta, out empty_t normal_meta, inout headers hdr, in metadata meta, in psa_ingress_output_metadata_t istd) {
    apply {
        buffer.emit<ethernet_t>(hdr.ethernet);
    }
}
control EgressDeparserImpl(packet_out buffer, out empty_t clone_e2e_meta, out empty_t recirculate_meta, inout headers hdr, in metadata meta, in psa_egress_output_metadata_t istd, in psa_egress_deparser_input_metadata_t edstd) {
    apply {
        buffer.emit<ethernet_t>(hdr.ethernet);
    }
}
IngressPipeline<headers, metadata, empty_t, empty_t, empty_t, empty_t>(IngressParserImpl(), ingress(), IngressDeparserImpl()) ip;
EgressPipeline<headers, metadata, empty_t, empty_t, empty_t, empty_t>(EgressParserImpl(), egress(), EgressDeparserImpl()) ep;
PSA_Switch<headers, metadata, headers, metadata, empty_t, empty_t, empty_t, empty_t, empty_t>(ip, PacketReplicationEngine(), ep, BufferingQueueingEngine()) main;
