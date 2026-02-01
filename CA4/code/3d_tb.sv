`timescale 1ns/1ps

module TOP_tb;

 
    reg clk;
    reg rst;
    reg start1;
    reg [3:0] start_address;
    wire finish;
    wire [15:0] out;
 
    TOP uut (
        .clk(clk),
        .rst(rst),
        .start1(start1),
        .start_address(start_address),
        .finish(finish),
        .out(out)
    );
 
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

   
    initial begin
   
        rst = 1;
        start1 = 0;
        start_address = 4'b0000;
        #10 rst = 0;  

 
        #10 start1 = 1; 
        start_address = 4'b0001; 
        #10 start1 = 0;  
   
        #100;

        $monitor("Time=%0t | start_address=%0b | finish=%0b | out=%0d", $time, start_address, finish, out);    
        #200;
        $stop;
    end

    initial begin
        $dumpfile("TOP_tb.vcd");
        $dumpvars(0, TOP_tb);
    end

endmodule

