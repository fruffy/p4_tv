#include <core.p4>
#include <v1model.p4>
typedef bit<48> EthernetAddress;
typedef int<32> MySignedInt;
struct mystruct1 {
    bit<4> a;
    bit<4> b;
}
struct mystruct2 {
    mystruct1 foo;
    bit<4>    a;
    bit<4>    b;
}
header Ethernet_h {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}
struct tuple_0 {
    bit<8>  field;
    bit<16> field_0;
}
typedef tuple_0 myTuple0;
struct myStruct1 {
    bit<7>          x1;
    int<33>         x2;
    EthernetAddress x3;
    MySignedInt     x4;
    varbit<56>      x5;
    varbit<104>     x6;
    error           x7;
    bool            x8;
    bit<32>         x9;
    Ethernet_h      x10;
    Ethernet_h[4]   x11;
    mystruct1       x12;
    mystruct2       x13;
    myTuple0        x14;
}