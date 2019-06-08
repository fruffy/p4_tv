#include <core.p4>
#include <v1model.p4>
header addr_type_t {
    bit<8> dstType;
    bit<8> srcType;
}
header addr_ipv4_t {
    bit<32> addr;
}
header addr_ipv6_t {
    bit<128> addr;
}
header_union addr_t {
    addr_ipv4_t ipv4;
    addr_ipv6_t ipv6;
}
struct metadata {
}
struct headers {
    addr_type_t addr_type;
    addr_t      addr_dst;
    addr_t      addr_src;
}
parser ProtParser(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    bit<8> addrType;
    addr_t addr_1;
    state start {
        packet.extract<addr_type_t>(hdr.addr_type);
        addrType = hdr.addr_type.dstType;
        addr_1.ipv4.setInvalid();
        addr_1.ipv6.setInvalid();
        transition select(addrType) {
            8w0x1: ProtAddrParser_ipv4;
            8w0x2: ProtAddrParser_ipv6;
        }
    }
    state ProtAddrParser_ipv4 {
        packet.extract<addr_ipv4_t>(addr_1.ipv4);
        transition start_0;
    }
    state ProtAddrParser_ipv6 {
        packet.extract<addr_ipv6_t>(addr_1.ipv6);
        transition start_0;
    }
    state start_0 {
        {
            hdr.addr_dst.ipv4 = addr_1.ipv4;
            hdr.addr_dst.ipv6 = addr_1.ipv6;
        }
        addrType = hdr.addr_type.srcType;
        addr_1.ipv4.setInvalid();
        addr_1.ipv6.setInvalid();
        transition select(addrType) {
            8w0x1: ProtAddrParser_ipv4_0;
            8w0x2: ProtAddrParser_ipv6_0;
        }
    }
    state ProtAddrParser_ipv4_0 {
        packet.extract<addr_ipv4_t>(addr_1.ipv4);
        transition start_1;
    }
    state ProtAddrParser_ipv6_0 {
        packet.extract<addr_ipv6_t>(addr_1.ipv6);
        transition start_1;
    }
    state start_1 {
        {
            hdr.addr_src.ipv4 = addr_1.ipv4;
            hdr.addr_src.ipv6 = addr_1.ipv6;
        }
        transition accept;
    }
}
control ProtVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}
control ProtIngress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}
control ProtEgress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}
control ProtComputeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}
control ProtDeparser(packet_out packet, in headers hdr) {
    apply {
        {
            packet.emit<addr_type_t>(hdr.addr_type);
            packet.emit<addr_ipv4_t>(hdr.addr_dst.ipv4);
            packet.emit<addr_ipv6_t>(hdr.addr_dst.ipv6);
            packet.emit<addr_ipv4_t>(hdr.addr_src.ipv4);
            packet.emit<addr_ipv6_t>(hdr.addr_src.ipv6);
        }
    }
}
V1Switch<headers, metadata>(ProtParser(), ProtVerifyChecksum(), ProtIngress(), ProtEgress(), ProtComputeChecksum(), ProtDeparser()) main;
