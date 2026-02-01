`timescale 1ns/1ns
module sevenSegmentDecoderBehavioral(input w, x, y, z, output [6:0] out);

    assign #6 out[0] = (w) | (y) | (x & z) | (~x & ~z);
    assign #6 out[1] = (~x) | (y & z) | (~y & ~z);
    assign #4 out[2] = (~y) | (z) | (x);
    assign #6 out[3] = (w) | (y & ~x) | (~x & ~z) | (y & ~z) | (x & ~y) | (x & ~y & z);
    assign #6 out[4] = (~x & ~z) | (y & ~z);
    assign #6 out[5] = (w) | (x & ~y) | (x & ~z) | (~y & ~z);
    assign #6 out[6] = (w) | (y & ~z) | (x & ~y) | (~x & y);



endmodule
