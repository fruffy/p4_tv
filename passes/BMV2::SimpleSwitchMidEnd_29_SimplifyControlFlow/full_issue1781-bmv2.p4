#include <core.p4>
#include <v1model.p4>
struct headers {
}
struct metadata {
}
parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    state start {
        transition accept;
    }
}
bit<32> test_func() {
    return 32w1;
}
control IngressImpl(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("IngressImpl.update_value") action update_value_0() {
    }
    apply {
        test_func();
        update_value_0();
    }
}
control VerifyChecksumImpl(inout headers hdr, inout metadata meta) {
    apply {
    }
}
control EgressImpl(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}
control ComputeChecksumImpl(inout headers hdr, inout metadata meta) {
    apply {
    }
}
control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
    }
}
V1Switch<headers, metadata>(ParserImpl(), VerifyChecksumImpl(), IngressImpl(), EgressImpl(), ComputeChecksumImpl(), DeparserImpl()) main;
