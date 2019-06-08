#include <core.p4>
#include <v1model.p4>
struct Headers {
}
struct Key {
    bit<32> field1;
}
struct Value {
    bit<32> field1;
}
struct Metadata {
}
parser P(packet_in b, out Headers p, inout Metadata meta, inout standard_metadata_t standard_meta) {
    state start {
        transition accept;
    }
}
control Ing(inout Headers headers, inout Metadata meta, inout standard_metadata_t standard_meta) {
    apply {
    }
}
control Eg(inout Headers hdrs, inout Metadata meta, inout standard_metadata_t standard_meta) {
    Key inKey;
    Key defaultKey;
    bool same;
    Value val_1;
    bool done;
    bool ok;
    Value val_2;
    bool cond;
    bool pred;
    @name("Eg.test") action test_0() {
        {
            inKey.field1 = 32w1;
        }
        {
            defaultKey.field1 = 32w0;
        }
        same = true && inKey.field1 == defaultKey.field1;
        {
            val_1.field1 = 32w0;
        }
        done = false;
        ok = !done && same;
        {
            {
                cond = ok;
                pred = cond;
                {
                    {
                        val_2.field1 = (pred ? val_1.field1 : val_2.field1);
                    }
                    val_2.field1 = (pred ? 32w8 : val_2.field1);
                    {
                        val_1.field1 = (pred ? val_2.field1 : val_1.field1);
                    }
                }
            }
        }
    }
    apply {
        test_0();
    }
}
control DP(packet_out b, in Headers p) {
    apply {
    }
}
control Verify(inout Headers hdrs, inout Metadata meta) {
    apply {
    }
}
control Compute(inout Headers hdr, inout Metadata meta) {
    apply {
    }
}
V1Switch<Headers, Metadata>(P(), Verify(), Ing(), Eg(), Compute(), DP()) main;