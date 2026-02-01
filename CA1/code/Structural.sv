`timescale 1ns/1ns
module sevenSegmentDecoder(input w, x, y, z, output [6:0] out);

    wire notx, noty, notz, notw;
    wire xbar_zbar, xbar_w, xz, yz, not_y_z, wbarx, yzbar, yxbar, xybar, ybarzbar, xzbar, xbary, xybarz;

    not #(1) g16(notx, x);
    not #(1) g17(noty, y);
    not #(1) g18(notz, z);
    not #(1) g19(notw, w);
    and #(2) g20(xybarz, x, noty, z);
    and #(2) g1(xbar_zbar, notx, notz);
    and #(2) g2(xbar_w, notx, w);
    and #(2) g3(xz, x, z);
    and #(2) g6(yz, y, z);
    and #(2) g7(not_y_z, noty, notz);
    and #(2) g8(yzbar, y, notz);
    and #(2) g9(wbarx, notw, x);
    and #(2) g10(yxbar, notx, y);
    and #(2) g11(xybar, x, noty);
    and #(2) g12(ybarzbar, noty, notz);
    and #(2) g13(xzbar, x, notz);
    and #(2) g14(xbary, notx, y);
    or #(3) a(out[0], w, y, xz, xbar_zbar);
    or #(3) b(out[1], notx, yz, not_y_z);
    or #(3) c(out[2], noty, z, x);
    or #(3) d(out[3], w, yzbar, xybarz, xbary, xbar_zbar); 
    or #(3) e(out[4], xbar_zbar, yzbar);
    or #(3) f(out[5], w, xybar, xzbar, ybarzbar);
    or #(3) g(out[6], w, yzbar, xybar, xbary);

endmodule

