#include <core.p4>
#include <v1model.p4>
header preamble_t {
    bit<336> data;
}
header prot_common_t {
    bit<4>  version;
    bit<6>  dstType;
    bit<6>  srcType;
    bit<16> totalLen;
    bit<8>  hdrLen;
    bit<8>  curri;
    bit<8>  currh;
    bit<8>  nextHdr;
}
header prot_addr_common_t {
    bit<128> data;
}
header prot_host_addr_ipv4_t {
    bit<32> addr;
}
header_union prot_host_addr_t {
    prot_host_addr_ipv4_t ipv4;
}
header prot_host_addr_padding_t {
    varbit<32> padding;
}
header prot_i_t {
    bit<7>  data;
    bit<1>  upDirection;
    bit<48> data2;
    bit<8>  segLen;
}
header prot_h_t {
    bit<64> data;
}
struct currenti_t {
    bit<1> upDirection;
}
struct metadata {
    bit<8> _headerLen0;
    bit<8> _hLeft1;
    bit<9> _addrLen2;
    bit<8> _currPos3;
    bit<1> _currenti_upDirection4;
}
struct headers {
    preamble_t               preamble;
    prot_common_t            prot_common;
    prot_addr_common_t       prot_addr_common;
    prot_host_addr_t         prot_host_addr_dst;
    prot_host_addr_t         prot_host_addr_src;
    prot_host_addr_padding_t prot_host_addr_padding;
    prot_i_t                 prot_inf_0;
    prot_h_t[10]             prot_h_0;
    prot_i_t                 prot_inf_1;
}
parser PROTParser(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    bit<9> paddingLen_0;
    bool currentISelected_0;
    bit<8> hdrLeft_0;
    bool currentISelected_1;
    prot_i_t inf_0;
    bit<8> meta_0_headerLen;
    bit<8> meta_0_hLeft;
    bit<9> meta_0_addrLen;
    bit<8> meta_0_currPos;
    currenti_t meta_0_currenti;
    bool currentISelected_2;
    bit<8> currI_0;
    bool subParser_currentISelected2;
    state start {
        packet.extract<preamble_t>(hdr.preamble);
        packet.extract<prot_common_t>(hdr.prot_common);
        packet.extract<prot_addr_common_t>(hdr.prot_addr_common);
        meta._headerLen0 = hdr.prot_common.hdrLen;
        packet.extract<prot_host_addr_ipv4_t>(hdr.prot_host_addr_dst.ipv4);
        meta._addrLen2 = 9w32;
        transition select(hdr.prot_common.srcType) {
            6w0x1: parse_prot_host_addr_src_ipv4;
        }
    }
    state parse_prot_host_addr_src_ipv4 {
        packet.extract<prot_host_addr_ipv4_t>(hdr.prot_host_addr_src.ipv4);
        meta._addrLen2 = meta._addrLen2 + 9w32;
        paddingLen_0 = 9w64 - (meta._addrLen2 & 9w63) & 9w63;
        packet.extract<prot_host_addr_padding_t>(hdr.prot_host_addr_padding, (bit<32>)paddingLen_0);
        meta._addrLen2 = meta._addrLen2 + paddingLen_0;
        meta._currPos3 = (bit<8>)(9w3 + (meta._addrLen2 >> 6));
        currentISelected_0 = hdr.prot_common.curri == meta._currPos3;
        inf_0.setInvalid();
        {
            meta_0_headerLen = meta._headerLen0;
            meta_0_hLeft = meta._hLeft1;
            meta_0_addrLen = meta._addrLen2;
            meta_0_currPos = meta._currPos3;
            {
                meta_0_currenti.upDirection = meta._currenti_upDirection4;
            }
        }
        currentISelected_2 = currentISelected_0;
        currI_0 = hdr.prot_common.curri;
        packet.extract<prot_i_t>(inf_0);
        subParser_currentISelected2 = currI_0 == meta_0_currPos;
        meta_0_currenti.upDirection = meta_0_currenti.upDirection + (bit<1>)subParser_currentISelected2 * inf_0.upDirection;
        meta_0_hLeft = inf_0.segLen;
        meta_0_currPos = meta_0_currPos + 8w1;
        hdr.prot_inf_0 = inf_0;
        {
            meta._headerLen0 = meta_0_headerLen;
            meta._hLeft1 = meta_0_hLeft;
            meta._addrLen2 = meta_0_addrLen;
            meta._currPos3 = meta_0_currPos;
            {
                meta._currenti_upDirection4 = meta_0_currenti.upDirection;
            }
        }
        transition parse_prot_h_0_pre;
    }
    state parse_prot_h_0_pre {
        transition select(meta._hLeft1) {
            8w0: parse_prot_1;
            default: parse_prot_h_0;
        }
    }
    state parse_prot_h_0 {
        packet.extract<prot_h_t>(hdr.prot_h_0.next);
        meta._hLeft1 = meta._hLeft1 + 8w255;
        meta._currPos3 = meta._currPos3 + 8w1;
        transition parse_prot_h_0_pre;
    }
    state parse_prot_1 {
        hdrLeft_0 = meta._headerLen0 - meta._currPos3;
        transition select(hdrLeft_0) {
            8w0: accept;
            default: parse_prot_inf_1;
        }
    }
    state parse_prot_inf_1 {
        currentISelected_1 = meta._currPos3 == hdr.prot_common.curri;
        inf_0.setInvalid();
        {
            meta_0_headerLen = meta._headerLen0;
            meta_0_hLeft = meta._hLeft1;
            meta_0_addrLen = meta._addrLen2;
            meta_0_currPos = meta._currPos3;
            {
                meta_0_currenti.upDirection = meta._currenti_upDirection4;
            }
        }
        currentISelected_2 = currentISelected_1;
        currI_0 = hdr.prot_common.curri;
        packet.extract<prot_i_t>(inf_0);
        subParser_currentISelected2 = currI_0 == meta_0_currPos;
        meta_0_currenti.upDirection = meta_0_currenti.upDirection + (bit<1>)subParser_currentISelected2 * inf_0.upDirection;
        meta_0_hLeft = inf_0.segLen;
        meta_0_currPos = meta_0_currPos + 8w1;
        hdr.prot_inf_1 = inf_0;
        {
            meta._headerLen0 = meta_0_headerLen;
            meta._hLeft1 = meta_0_hLeft;
            meta._addrLen2 = meta_0_addrLen;
            meta._currPos3 = meta_0_currPos;
            {
                meta._currenti_upDirection4 = meta_0_currenti.upDirection;
            }
        }
        transition accept;
    }
}
control PROTVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}
control PROTIngress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
        if (meta._currenti_upDirection4 == 1w0) 
            mark_to_drop(standard_metadata);
    }
}
control PROTEgress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}
control PROTComputeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}
control PROTDeparser(packet_out packet, in headers hdr) {
    apply {
        {
            packet.emit<preamble_t>(hdr.preamble);
            packet.emit<prot_common_t>(hdr.prot_common);
            packet.emit<prot_addr_common_t>(hdr.prot_addr_common);
            packet.emit<prot_host_addr_ipv4_t>(hdr.prot_host_addr_dst.ipv4);
            packet.emit<prot_host_addr_ipv4_t>(hdr.prot_host_addr_src.ipv4);
            packet.emit<prot_host_addr_padding_t>(hdr.prot_host_addr_padding);
            packet.emit<prot_i_t>(hdr.prot_inf_0);
            packet.emit<prot_h_t>(hdr.prot_h_0[0]);
            packet.emit<prot_h_t>(hdr.prot_h_0[1]);
            packet.emit<prot_h_t>(hdr.prot_h_0[2]);
            packet.emit<prot_h_t>(hdr.prot_h_0[3]);
            packet.emit<prot_h_t>(hdr.prot_h_0[4]);
            packet.emit<prot_h_t>(hdr.prot_h_0[5]);
            packet.emit<prot_h_t>(hdr.prot_h_0[6]);
            packet.emit<prot_h_t>(hdr.prot_h_0[7]);
            packet.emit<prot_h_t>(hdr.prot_h_0[8]);
            packet.emit<prot_h_t>(hdr.prot_h_0[9]);
            packet.emit<prot_i_t>(hdr.prot_inf_1);
        }
    }
}
V1Switch<headers, metadata>(PROTParser(), PROTVerifyChecksum(), PROTIngress(), PROTEgress(), PROTComputeChecksum(), PROTDeparser()) main;