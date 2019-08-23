#include <core.p4>
#include <v1model.p4>
header h1_t {
    bit<8> f1;
    bit<8> f2;
}
struct headers_t {
    h1_t h1;
}
struct metadata_t {
}
control ingressImpl(inout headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    bit<8> tmp_1;
    bit<8> tmp_2;
    apply {
        tmp_2 = hdr.h1.f1;
        tmp_1 = tmp_2 >> 2;
        hdr.h1.f1 = tmp_1;
        hdr.h1.f2 = 8w5 >> 2;
    }
}
parser parserImpl(packet_in packet, out headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    state start {
        transition accept;
    }
}
control verifyChecksum(inout headers_t hdr, inout metadata_t meta) {
    apply {
    }
}
control egressImpl(inout headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    apply {
    }
}
control updateChecksum(inout headers_t hdr, inout metadata_t meta) {
    apply {
    }
}
control deparserImpl(packet_out packet, in headers_t hdr) {
    apply {
    }
}
V1Switch<headers_t, metadata_t>(parserImpl(), verifyChecksum(), ingressImpl(), egressImpl(), updateChecksum(), deparserImpl()) main;