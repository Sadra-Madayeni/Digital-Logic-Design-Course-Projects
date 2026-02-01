module Encoder(input [15:0] OneHot, output reg [3:0] Binary);
    integer i;
    always @(*) begin
        Binary = 4'b0000; 
        for (i = 0; i < 16; i = i + 1) begin
            if (OneHot[i]) begin
                Binary = i[3:0];
            end
        end
    end
endmodule


module Decoder(input [3:0] Binary, output reg [15:0] OneHot);
    integer i;
    always @(*) begin
        OneHot = 16'b0; 
        for (i = 0; i < 16; i = i + 1) begin
            if (i == Binary) begin
                OneHot[i] = 1'b1; 
            end
        end
    end
endmodule

module Comperator(input [3:0] a, b, output E, AgB, BgA);
    wire i1, i2, i3, i4, i5, i6, i7, i8;
    wire NotB0, NotB1, NotB2, NotB3;

    xnor XNOR1(i1, a[0], b[0]);
    xnor XNOR2(i2, a[1], b[1]);
    xnor XNOR3(i3, a[2], b[2]);
    xnor XNOR4(i4, a[3], b[3]);

    not B3(NotB3, b[3]);
    not B2(NotB2, b[2]);
    not B1(NotB1, b[1]);
    not B0(NotB0, b[0]);

    and a1(i5, NotB3, a[3]);
    and a2(i6, NotB2, a[2], i3);
    and a3(i7, NotB1, i3, i2, a[1]);
    and a4(i8, NotB0, i3, i2, i1, a[0]);

    and Equal(E, i4, i3, i2, i1);
    or AgreaterThanB(AgB, i5, i6, i7, i8);

    nor (BgA, E, AgB);
endmodule

module CLA_4bit(A, B, Carryin, S, Carryout);


    input [3:0] A, B;  
    input Carryin;     
    output [3:0] S;   
    output Carryout;       
    wire [3:0] P, G;   
    wire [3:0] C;      
    wire t1, t2, t3, t4, t5, t6, t7, i0, i1, i2, i3;

    and (G[0], A[0], i0);  
    and (G[1], A[1], i1); 
    and (G[2], A[2], i2); 
    and (G[3], A[3], i3); 

    xor (P[0], A[0], i0); 
    xor (P[1], A[1], i1); 
    xor (P[2], A[2], i2); 
    xor (P[3], A[3], i3);

    xor(i0, Carryin, B[0]);
    xor(i1, Carryin, B[1]);
    xor(i2, Carryin, B[2]);
    xor(i3, Carryin, B[3]);


    and (t1, P[0], Carryin);
    or (C[1], G[0], t1);

    and (t2, P[1], G[0]);
    and (t3, P[1], P[0], Carryin);
    or (C[2], G[1], t2, t3);

    and (t4, P[2], G[1]);
    and (t5, P[2], P[1], G[0]);
    and (t6, P[2], P[1], P[0], Carryin);
    or (C[3], G[2], t4, t5, t6);

    and (t7, P[3], C[3]);
    or (Carryout, G[3], t7);

    xor (S[0], P[0], Carryin);     
    xor (S[1], P[1], C[1]);  
    xor (S[2], P[2], C[2]);    
    xor (S[3], P[3], C[3]);    

endmodule

module Arithmetic_Logic_Unit(input [2:0] Opcode,input [3:0] a, b, output reg [3:0] Result, output overflow);
reg [3:0] Sum;
reg Cin;
wire Equal, Grater, Lower;
CLA_4bit CLA(a,b,Cin, Sum,overflow);
Comperator CMP(a,b, Equal, Lower, Grater);


    always @(*) 
    begin
        if (Opcode == 3'b001)
        begin
            Cin = 0;
            Result = Sum;    
        end
        else if (Opcode == 3'b010)
        begin
            Cin = 1;
            Result = Sum;
        end 
        else if (Opcode == 3'b011)
        begin
            Cin = 1;
            if(Sum[3] == 0) 
            begin
                Result = a;
            end 
            else 
            begin
                Result = b;
            end 
        end
        else if (Opcode == 3'b100)
        begin
            Cin = 1;
            if(Sum[3] == 0)
            begin
                Result = b;
            end
            else
            begin
                Result = a;
            end        
        end
        else if(Opcode == 3'b101)
        begin
            if(Grater == 1)
            begin
                Result = b;
            end
            else
            begin
                Result = a;
            end
        end
        else if(Opcode == 3'b110)
        begin
            if(Grater == 1)
            begin
                Result = a;
            end
            else
            begin
                Result = b;
            end
        end
        else if(Opcode == 3'b111)
        begin
            Result = b;
        end
    end
    endmodule
        
module Top_Module(input [15:0] inp1, inp2, input [2:0] Opc, output [15:0] out, output overflow);

wire [3:0] out1, out2;
wire [3:0] result;
Encoder Enc1(inp1, out1);
Encoder Enc2(inp2, out2);
Arithmetic_Logic_Unit ALU(Opc, out1, out2, result, overflow);
Decoder Dec(result, out);

endmodule
