`timescale 1ns / 1ps

module result_tb;    
    reg [3:0] start_address;
    reg clock;
    reg reset;
    reg start;
 
    wire [3:0] dout;
    wire [15:0] out;
    wire finish;  

    result uut (
        .clk(clock),
        .rst(reset),
        .start(start),
        .start_address(start_address),
        .dout(dout),
        .out(out),
        .finish(finish)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;  
    end

    initial begin
 
        start_address = 4'b0000;
        reset = 0;
        start = 0;
     
        $display("Starting Testbench");
     
        reset = 1;
        #10;
        reset = 0;
   
        start = 1;
        #10;
        start = 0;

        wait(finish);
        $display("Output: dout = %b, out = %d", dout, out);

        $display("Testbench completed");
        $finish;
    end

endmodule

