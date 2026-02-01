module Async_D_Latch(input D, en, Clk, rst, output q, qbar);
    wire NotD, NotR, o, o1, o2, noto;

    not(NotD, D);
    not(NotR, rst);
    and(o, D, NotR);
    nand(o1, Clk, o, en);
    nand(o2, Clk, en, NotD);
    nand Q(q, qbar, o1);
    nand Qbar(qbar, NotR, o2, q);
endmodule

module D_flip_flop (input D, en, Clk, rst, output Q);
    wire Qbar, NotQMaster, QMaster;

    Async_D_Latch Master(.D(D), .en(en), .Clk(~Clk), .rst(rst), .q(QMaster), .qbar(NotQMaster));
    
    Async_D_Latch Slave(.D(QMaster), .en(en), .Clk(Clk), .rst(rst), .q(Q), .qbar(Qbar));
endmodule


module Shift_Register #(parameter n = 24)(input shift_en, Clk, Ser_In, Par_Load, rst, input[n-1:0] Par_In, output reg Ser_Out, output reg[n-1:0] Par_Out);
    reg[n-1:0] D;
    assign D[n-1] = (Ser_In & ~Par_Load) | (Par_In[n-1] & Par_Load);
    D_flip_flop FF(.D(D[n-1]), .en(1'b1), .Clk(Clk), .rst(rst), .Q(Par_Out[n-1]));
    genvar  i;
    generate
        
    for (i = n - 2 ; i >= 0 ; i = i - 1 ) begin
        assign D[i] = (Par_Out[ i + 1 ] & ~Par_Load) | (Par_In[i] & Par_Load);
        D_flip_flop FF(.D(D[i]), .en(1'b1), .Clk(Clk), .rst(rst), .Q(Par_Out[i]));
    end

    endgenerate
    assign Ser_Out = Par_Out[0];
    
endmodule

module LFSR(input rst, shift_en, Clk, Par_Load, input [79:0] Par_In,output Ser_Out, output [79:0] Par_Out);
    wire Ser_In;
    assign Ser_In = Par_Out[62] ^ Par_Out[51] ^ Par_Out[38] ^ Par_Out[23] ^ Par_Out[13] ^ Par_Out[0];
    Shift_Register #(.n(80)) SR(shift_en, Clk, Ser_In,Par_Load, rst, Par_In, Ser_Out, Par_Out);
endmodule 

module NFSR(input rst, shift_en, Clk, Par_Load, input [23:0] Par_In,output Ser_Out, output [23:0] Par_Out);
    wire Ser_In;
    assign Ser_In = Par_Out[0] ^ Par_Out[5] ^ Par_Out[6] ^ Par_Out[9] ^ Par_Out[17] ^ Par_Out[22] ^ (Par_Out[4] & Par_Out[13]) ^ (Par_Out[8] & Par_Out[16]) ^ (Par_Out[5] ^ Par_Out[11] ^ Par_Out[14]) ^ (Par_Out[2] ^ Par_Out[5] ^ Par_Out[8] ^ Par_Out[10] );
    Shift_Register #(.n(24)) SR(shift_en, Clk, Ser_In,Par_Load, rst, Par_In, Ser_Out, Par_Out);
endmodule
module NFSR_Grain(input rst, shift_en,i, Clk, Par_Load, input [23:0] Par_In,output Ser_Out, output [23:0] Par_Out);
    wire Ser_In, t;
    assign t = Par_Out[0] ^ Par_Out[5] ^ Par_Out[6] ^ Par_Out[9] ^ Par_Out[17] ^ Par_Out[22] ^ (Par_Out[4] & Par_Out[13]) ^ (Par_Out[8] & Par_Out[16]) ^ (Par_Out[5] ^ Par_Out[11] ^ Par_Out[14]) ^ (Par_Out[2] ^ Par_Out[5] ^ Par_Out[8] ^ Par_Out[10] );
    Shift_Register #(.n(24)) SR(shift_en, Clk, Ser_In,Par_Load, rst, Par_In, Ser_Out, Par_Out);
    assign Ser_In = t ^ i;
endmodule

 
module Grain(input rst, shift_en, Clk, Par_Load,input [103:0] Par_In,output f, output [79:0] Linear, output [23:0] NonLinear);
    wire SerOut_LFSR, SerOut_NFSR;
    wire t;
    Shift_Register #(.n(24)) SR(shift_en, Clk, Ser_In,Par_Load, rst, Par_In, Ser_Out, Par_Out);
    LFSR LF(rst, shift_en, Clk, Par_Load, Par_In[79:0],SerOut_LFSR, Linear);
    NFSR NF(rst, shift_en, Clk, Par_Load, Par_In[103:80],SerOut_NFSR, NonLinear);
    assign t = Linear[0] ^ Linear[3] ^ (Linear[1] & Linear[2]) ^ NonLinear[0] ^ (NonLinear[1] & Linear[5]) ^ (NonLinear[3] & Linear[7]) ^ (Linear[8] & Linear[13] & NonLinear[5]) ^ NonLinear[2];
    assign f = t ^ SerOut_NFSR ;

endmodule
 


