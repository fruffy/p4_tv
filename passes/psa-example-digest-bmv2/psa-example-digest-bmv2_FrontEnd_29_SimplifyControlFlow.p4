#include <core.p4>
#include <psa.p4>
enum bit<16> EthTypes {
    IPv4 = 16w0x800,
    ARP = 16w0x806,
    RARP = 16w0x8035,
    EtherTalk = 16w0x809b,
    VLAN = 16w0x8100,
    IPX = 16w0x8137,
    IPv6 = 16w0x86dd
}
typedef bit<48> EthernetAddress;
header ethernet_t {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}
header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}
struct headers {
    ethernet_t ethernet;
    ipv4_t     ipv4;
    EthTypes   type;
}
struct empty_metadata_t {
}
struct mac_learn_digest_t {
    EthernetAddress srcAddr;
    PortId_t        ingress_port;
}
struct metadata {
    bool               send_mac_learn_msg;
    mac_learn_digest_t mac_learn_msg;
}
parser CommonParser(packet_in buffer, out headers parsed_hdr, inout metadata meta) {
    state start {
        buffer.extract<ethernet_t>(parsed_hdr.ethernet);
        transition select(parsed_hdr.ethernet.etherType) {
            16w0x800: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        buffer.extract<ipv4_t>(parsed_hdr.ipv4);
        transition accept;
    }
}
parser IngressParserImpl(packet_in buffer, out headers parsed_hdr, inout metadata meta, in psa_ingress_parser_input_metadata_t istd, in empty_metadata_t resubmit_meta, in empty_metadata_t recirculate_meta) {
    @name("p") CommonParser() p_0;
    state start {
        p_0.apply(buffer, parsed_hdr, meta);
        transition accept;
    }
}
parser EgressParserImpl(packet_in buffer, out headers parsed_hdr, inout metadata meta, in psa_egress_parser_input_metadata_t istd, in empty_metadata_t normal_meta, in empty_metadata_t clone_i2e_meta, in empty_metadata_t clone_e2e_meta) {
    @name("p") CommonParser() p_1;
    state start {
        p_1.apply(buffer, parsed_hdr, meta);
        transition accept;
    }
}
control ingress(inout headers hdr, inout metadata meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
    @name("unknown_source") action unknown_source_0() {
        meta.send_mac_learn_msg = true;
        meta.mac_learn_msg.srcAddr = hdr.ethernet.srcAddr;
        meta.mac_learn_msg.ingress_port = istd.ingress_port;
    }
    @name("learned_sources") table learned_sources_0 {
        key = {
            hdr.ethernet.srcAddr: exact @name("hdr.ethernet.srcAddr") ;
        }
        actions = {
            NoAction();
            unknown_source_0();
        }
        default_action = unknown_source_0();
    }
    @name("do_L2_forward") action do_L2_forward_0(PortId_t egress_port) {
        send_to_port(ostd, egress_port);
    }
    @name("do_tst") action do_tst_0(PortId_t egress_port, EthTypes serEnumT) {
        send_to_port(ostd, egress_port);
    }
    @name("l2_tbl") table l2_tbl_0 {
        key = {
            hdr.ethernet.dstAddr: exact @name("hdr.ethernet.dstAddr") ;
        }
        actions = {
            do_L2_forward_0();
            NoAction();
        }
        default_action = NoAction();
    }
    @name("tst_tbl") table tst_tbl_0 {
        key = {
            meta.mac_learn_msg.ingress_port: exact @name("meta.mac_learn_msg.ingress_port") ;
        }
        actions = {
            do_tst_0();
            NoAction();
        }
        default_action = NoAction();
    }
    apply {
        meta.send_mac_learn_msg = false;
        learned_sources_0.apply();
        l2_tbl_0.apply();
        tst_tbl_0.apply();
    }
}
control egress(inout headers hdr, inout metadata meta, in psa_egress_input_metadata_t istd, inout psa_egress_output_metadata_t ostd) {
    apply {
    }
}
control CommonDeparserImpl(packet_out packet, inout headers hdr) {
    apply {
        packet.emit<ethernet_t>(hdr.ethernet);
        packet.emit<ipv4_t>(hdr.ipv4);
    }
}
control IngressDeparserImpl(packet_out packet, out empty_metadata_t clone_i2e_meta, out empty_metadata_t resubmit_meta, out empty_metadata_t normal_meta, inout headers hdr, in metadata meta, in psa_ingress_output_metadata_t istd) {
    @name("common_deparser") CommonDeparserImpl() common_deparser_0;
    @name("mac_learn_digest") Digest<mac_learn_digest_t>() mac_learn_digest_0;
    apply {
        if (meta.send_mac_learn_msg) {
            mac_learn_digest_0.pack(meta.mac_learn_msg);
        }
        common_deparser_0.apply(packet, hdr);
    }
}
control EgressDeparserImpl(packet_out packet, out empty_metadata_t clone_e2e_meta, out empty_metadata_t recirculate_meta, inout headers hdr, in metadata meta, in psa_egress_output_metadata_t istd, in psa_egress_deparser_input_metadata_t edstd) {
    @name("common_deparser") CommonDeparserImpl() common_deparser_1;
    apply {
        common_deparser_1.apply(packet, hdr);
    }
}
IngressPipeline<headers, metadata, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(IngressParserImpl(), ingress(), IngressDeparserImpl()) ip;
EgressPipeline<headers, metadata, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(EgressParserImpl(), egress(), EgressDeparserImpl()) ep;
PSA_Switch<headers, metadata, headers, metadata, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(ip, PacketReplicationEngine(), ep, BufferingQueueingEngine()) main;