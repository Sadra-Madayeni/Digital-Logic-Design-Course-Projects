module T;
    reg rst, shift_en, Clk, Par_Load;
    reg [103:0] Par_In; 
    wire f;
    wire [79:0] Linear;  
    wire [23:0] NonLinear; 

  
    Grain grain_inst (
        .rst(rst),
        .shift_en(shift_en),
        .Clk(Clk),
        .Par_Load(Par_Load),
        .Par_In(Par_In),
        .f(f),
        .Linear(Linear),
        .NonLinear(NonLinear)
    );

 
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;  
    end

   
    initial begin
       
        rst = 1;
        shift_en = 0;
        Par_Load = 1;
        Par_In = 104'h123456aaaaaaaaaaaaaaaaaaaa; 
         
        #10 rst = 0;
        
        #10 Par_Load = 0; shift_en = 1;

       
        #100; 

         
    end

    
    initial begin
        $monitor($time, " f = %b, Linear = %h, NonLinear = %h", f, Linear, NonLinear);
    end
endmodule
