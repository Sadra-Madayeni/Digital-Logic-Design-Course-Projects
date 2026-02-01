module Register1(input clk, reset, en, input [7:0] data_in, output reg [7:0] data_out);
    always @(posedge clk) begin
        if (reset)
            data_out <= 8'b0;
        else if (en)
            data_out <= data_in;
    end
endmodule

module Register2(input clk, reset, en, input [15:0] data_in, output reg [15:0] data_out);
    always @(posedge clk) begin
        if (reset)
            data_out <= 16'b0;
        else if (en)
            data_out <= data_in;
    end
endmodule

 module Decoder(input [1:0] Radd, input en, output reg [3:0] Y);
    always @(*) begin
        if (en)
            case (Radd)
                2'b00: Y = 4'b0001;
                2'b01: Y = 4'b0010;
                2'b10: Y = 4'b0100;
                2'b11: Y = 4'b1000;
                default: Y = 4'b0000;
            endcase
        else
            Y = 4'b0000;
    end
endmodule

module Multiplier(input signed [7:0] a, b, output signed [15:0]  result);
    assign result = a * b;
endmodule

module invert(input a, output reg f);
    always @(*) begin
        f = ~a;
    end
endmodule

module four_bit_counter(input [3:0] start_address, input clk, enable, load, output reg [3:0] q);
    always @(posedge clk) begin
        if (load) begin
         q <= start_address;
        end else if (enable) begin 
            q <= q + 1;
        end
    end
endmodule

module Subtractor(input signed [15:0] a, b, output signed [15:0] result);
    assign result = b - a;
endmodule

module mux(input sel, input [7:0] a, b, output [7:0] f);
    assign f = sel ? b : a;
endmodule

module dataPath(input clk, counetr_load, counter_enable, en, rst, sel, input [3:0] start_address, input [7:0] data_in, input [1:0] Radd, output [3:0] dout, output [15:0] out);
    wire invert_mux_sel;
    wire [3:0] q;
    wire [3:0] Y;
    wire [7:0] f1, f2, f3, f4;
    wire [7:0] mux1res, mux2res;
    wire [15:0] multires, subres, f5, f6;


    invert Inverter(sel, invert_mux_sel);

    four_bit_counter counter(start_address, clk, counter_enable, counetr_load, q);

    assign dout = q;

    Decoder dec(Radd, en, Y);

    Register1 A(clk, rst, Y[0], data_in, f1);
    Register1 B(clk, rst, Y[1], data_in, f2);
    Register1 C(clk, rst, Y[2], data_in, f3);
    Register1 D(clk, rst, Y[3], data_in, f4);

    mux Multiplexer1(sel, f1, f2, mux1res);
    mux Multiplexer2(sel, f4, f3, mux2res);

    Multiplier mul(mux1res, mux2res ,multires);

    Register2 E(clk, rst, sel, multires, f5);
    Register2 F(clk, rst, invert_mux_sel, multires, f6);

    Subtractor sub(f5, f6, subres);

    assign out = subres;


endmodule

module Control(input clk, rst, start, output reg counetr_load , counter_enable, decoder_enable, sel, finish, output reg [1:0] Radd);

    reg [3:0] ns, ps;

    parameter init = 4'b0000, S1 =  4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000;

    always @(posedge clk or posedge rst) begin
        if (rst) 
            ps <= init;
        else 
            ps <= ns;
    end

    always @(posedge start or ps) begin

        case(ps)
            init: begin 
                    counetr_load = 1'b0;
                    counter_enable = 1'b0;
                    decoder_enable = 1'b0;
                    sel = 1'b0;
                    finish = 1'b0;
                    Radd = 2'b00;
                if (start)  begin 
                    decoder_enable = 1'b1;
                    counetr_load = 1'b1;
                    Radd = 2'b00;
                    ns = S1;
                end else begin
                    ns = init;
                end
            end

            S1: begin
                    Radd = 2'b00;
                    counetr_load = 1'b0;
                    counter_enable = 1'b1;
                    ns = S2;
            end
            S2 : begin
                    Radd = 2'b01;
                    decoder_enable = 1'b1;
                    ns = S3;
            end
            S3: begin 
                    Radd = 2'b10;
                    ns = S4;
            end
            S4: begin 
                    Radd = 2'b11;
                    ns = S5;
            end
            S5 : begin
                    decoder_enable = 1'b0;
                    counetr_load = 1'b0;
                    sel = 1'b0;
                    counter_enable = 1'b0;
                    ns = S6;
            end
            S6 : begin 
                    sel = 1'b1;
                    ns = S7;
            end
            S7: begin
                ns = S8;
            end
            S8: begin
                finish = 1;
                ns = init;
            end
            default: ns = init;
    endcase
end

endmodule
 
module ROM(addrBus, outBus);

  //parameter
  parameter  BW=8 ;
  parameter  N=16 ;
  //input
  input [$clog2(N) - 1 :0]addrBus;
  //output   
  output [BW - 1 :0] outBus;
  //memory declarations
  reg [BW - 1 :0] ROMData[0 : N - 1 ];
  reg [BW - 1 :0] outReg;
  
  integer i;
  initial begin
    for(i = 0; i < N; i = i+1)
      ROMData[i] = 8'b0; 
      $readmemb( "ROM_data.txt" ,ROMData,0 , (N-1) );   
  end

  assign outBus = ROMData[addrBus];

endmodule

module determinant(input clk, rst, start, input [3:0] start_address, input [7:0 ] data_input ,  output [3:0] dout, output done, output [15:0] out);
    
    wire [1:0] Radd;
    wire counetr_load, counter_enable, decoder_enable, sel;

    dataPath d(clk,counetr_load, counter_enable, decoder_enable, rst, sel, start_address, data_input, Radd, dout, out);
    Control c(clk, rst, start, counetr_load, counter_enable, decoder_enable,sel, done, Radd);


endmodule

module result (input clk, start, rst, input [3:0] start_address, output [3:0] dout, output [15:0] out , output finish);

    wire [7:0] data_in;

    determinant Done(clk, rst, start, start_address, data_in, dout, finish, out);

    ROM storage(dout, data_in);

endmodule



