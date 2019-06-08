error {
    UnreachableState
}
#include <core.p4>
#include <v1model.p4>
typedef bit<9> egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}
header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}
struct test_digest_t {
    macAddr_t in_mac_srcAddr;
    error     my_parser_error;
    bit<32>   pkt_type;
}
struct test_digest2_t {
    macAddr_t in_mac_dstAddr;
    bit<8>    my_thing;
}
struct test_digest3_t {
    bit<16> in_mac_etherType;
}
struct metadata {
    test_digest_t  test_digest;
    test_digest2_t test_digest2;
    test_digest3_t test_digest3;
}
struct headers {
    ethernet_t ethernet;
    ipv4_t     ipv4;
}
parser MyParser(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    state start {
        packet.extract<ethernet_t>(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            16w0x800: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        packet.extract<ipv4_t>(hdr.ipv4);
        transition accept;
    }
}
control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}
control MyIngress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name(".NoAction") action NoAction_0() {
    }
    @name(".NoAction") action NoAction_1() {
    }
    @name("MyIngress.set_dmac") action set_dmac_0(macAddr_t dstAddr) {
        hdr.ethernet.dstAddr = dstAddr;
    }
    @name("MyIngress.drop") action drop_0() {
    }
    @name("MyIngress.drop") action drop_3() {
    }
    @name("MyIngress.forward") table forward {
        key = {
            hdr.ipv4.dstAddr: exact @name("hdr.ipv4.dstAddr") ;
        }
        actions = {
            set_dmac_0();
            drop_0();
            NoAction_0();
        }
        size = 1024;
        default_action = NoAction_0();
    }
    @name("MyIngress.set_nhop") action set_nhop_0(ip4Addr_t dstAddr, egressSpec_t port) {
        hdr.ipv4.dstAddr = dstAddr;
        standard_metadata.egress_spec = port;
    }
    @name("MyIngress.ipv4_lpm") table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm @name("hdr.ipv4.dstAddr") ;
        }
        actions = {
            set_nhop_0();
            drop_3();
            NoAction_1();
        }
        size = 1024;
        default_action = NoAction_1();
    }
    @name("MyIngress.send_digest") action send_digest_0() {
        meta.test_digest.in_mac_srcAddr = hdr.ethernet.srcAddr;
        meta.test_digest.my_parser_error = error.PacketTooShort;
        meta.test_digest.pkt_type = 32w0;
        digest<test_digest_t>(32w1, meta.test_digest);
        meta.test_digest2.in_mac_dstAddr = hdr.ethernet.dstAddr;
        meta.test_digest2.my_thing = 8w42;
        digest<test_digest2_t>(32w2, meta.test_digest2);
        meta.test_digest3.in_mac_etherType = hdr.ethernet.etherType;
        digest<test_digest3_t>(32w3, meta.test_digest3);
    }
    apply {
        ipv4_lpm.apply();
        forward.apply();
        send_digest_0();
    }
}
control MyEgress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name(".NoAction") action NoAction_5() {
    }
    @name("MyEgress.rewrite_mac") action rewrite_mac_0(macAddr_t srcAddr) {
        hdr.ethernet.srcAddr = srcAddr;
        hdr.ipv4.ttl = hdr.ipv4.ttl + 8w255;
    }
    @name("MyEgress.send_frame") table send_frame {
        key = {
            standard_metadata.egress_port: exact @name("standard_metadata.egress_port") ;
        }
        actions = {
            rewrite_mac_0();
            NoAction_5();
        }
        size = 1024;
        default_action = NoAction_5();
    }
    apply {
        send_frame.apply();
    }
}
control MyComputeChecksum(inout headers hdr, inout metadata meta) {
    apply {
        update_checksum<tuple<bit<4>, bit<4>, bit<8>, bit<16>, bit<16>, bit<3>, bit<13>, bit<8>, bit<8>, bit<32>, bit<32>>, bit<16>>(hdr.ipv4.isValid(), { hdr.ipv4.version, hdr.ipv4.ihl, hdr.ipv4.diffserv, hdr.ipv4.totalLen, hdr.ipv4.identification, hdr.ipv4.flags, hdr.ipv4.fragOffset, hdr.ipv4.ttl, hdr.ipv4.protocol, hdr.ipv4.srcAddr, hdr.ipv4.dstAddr }, hdr.ipv4.hdrChecksum, HashAlgorithm.csum16);
    }
}
control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit<ethernet_t>(hdr.ethernet);
        packet.emit<ipv4_t>(hdr.ipv4);
    }
}
V1Switch<headers, metadata>(MyParser(), MyVerifyChecksum(), MyIngress(), MyEgress(), MyComputeChecksum(), MyDeparser()) main;