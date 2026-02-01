`timescale 1ns / 1ns

module Top_Module_tb;

    reg [15:0] Inp1;
    reg [15:0] Inp2;
    reg [2:0] Opc;

    wire [15:0] Output;
    wire overflow;

    Top_Module uut (
        .inp1(Inp1),
        .inp2(Inp2),
        .Opc(Opc),
        .out(Output),
        .overflow(overflow)
    );

    initial begin
      
        Inp1 = 16'b0000000000000010; 
        Inp2 = 16'b0000000000001000; 
        Opc = 3'b000;               
        
      
        #10; Opc = 3'b001; 
        #10; $display("Opcode: %b, Output: %b, Overflow: %b", Opc, Output, overflow);
        
        #10; Opc = 3'b010;
        #10; $display("Opcode: %b, Output: %b, Overflow: %b", Opc, Output, overflow);
        
        #10; Opc = 3'b011; 
        #10; $display("Opcode: %b, Output: %b, Overflow: %b", Opc, Output, overflow);
        
        #10; Opc = 3'b100; 
        #10; $display("Opcode: %b, Output: %b, Overflow: %b", Opc, Output, overflow);
        
        #10; Opc = 3'b101; 
        #10; $display("Opcode: %b, Output: %b, Overflow: %b", Opc, Output, overflow);
        
        #10; Opc = 3'b110; 
        #10; $display("Opcode: %b, Output: %b, Overflow: %b", Opc, Output, overflow);
        
        #10; Opc = 3'b111; 
        #10; $display("Opcode: %b, Output: %b, Overflow: %b", Opc, Output, overflow);

        #10;
    end

endmodule

