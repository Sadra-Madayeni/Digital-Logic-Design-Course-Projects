module TestBench;
    reg [15:0] inp1, inp2;
    reg [2:0] Opc;
    wire [15:0] out;
    wire overflow;
    wire [6:0] SevenSegment;

    Top_Module uut (
        .inp1(inp1),
        .inp2(inp2),
        .Opc(Opc),
        .out(out),
        .overflow(overflow),
        .SevenSegment(SevenSegment)
    );

    initial begin
        inp1 = 16'b0000_0000_0000_0001;
        inp2 = 16'b0000_0000_0000_0010;
        Opc = 3'b001;
        #10;
        $display("Addition Test:");
        $display("Input 1: %b, Input 2: %b, Opcode: %b", inp1, inp2, Opc);
        $display("Output: %b, Overflow: %b, SevenSegment: %b\n", out, overflow, SevenSegment);

        inp1 = 16'b0000_0000_0000_0001;
        inp2 = 16'b0000_0000_0000_0010;
        Opc = 3'b010;
        #10;
        $display("Subtraction Test:");
        $display("Input 1: %b, Input 2: %b, Opcode: %b", inp1, inp2, Opc);
        $display("Output: %b, Overflow: %b, SevenSegment: %b\n", out, overflow, SevenSegment);
    end
endmodule

