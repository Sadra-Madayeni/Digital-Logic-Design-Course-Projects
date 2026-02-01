`timescale 1ns/1ns
module behavioralTestBench();
    reg w, x, y, z;
    wire [6:0]test_out;

    sevenSegmentDecoderBehavioral test(w, x, y, z,test_out);
    
    initial begin
       
        w = 0; x = 0; y = 0; z = 0; #10;
        w = 0; x = 0; y = 0; z = 1; #10;
        w = 0; x = 0; y = 1; z = 0; #10;
        w = 0; x = 0; y = 1; z = 1; #10;
        w = 0; x = 1; y = 0; z = 0; #10;
        w = 0; x = 1; y = 0; z = 1; #10;
        w = 0; x = 1; y = 1; z = 0; #10;
        w = 0; x = 1; y = 1; z = 1; #10;
        w = 1; x = 0; y = 0; z = 0; #10;
        w = 1; x = 0; y = 0; z = 1; #10;
        w = 1; x = 0; y = 1; z = 0; #10;
        w = 1; x = 0; y = 1; z = 1; #10;
        w = 1; x = 1; y = 0; z = 0; #10;
        w = 1; x = 1; y = 0; z = 1; #10;
        w = 1; x = 1; y = 1; z = 0; #10;
        w = 1; x = 1; y = 1; z = 1; #10;
	#30;
     
    end
endmodule

