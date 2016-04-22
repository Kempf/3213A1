`timescale 10ns / 10ns

module tb_tweetboard;

    reg sysclk;
    reg reset, serialIn, btn_write;
    wire out, out_debug, in_debug;

    tweetboard UUT( 
			.sysclk(sysclk),
			.reset(reset),
			.serialIn(serialIn),
			.btn_write(btn_write),
			.out_fin(out),
			.out_debug(out_debug),
			.in_debug(in_debug)
    );
        
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("tweetboard.vcd");
        $dumpvars;
		  serialIn = 1'b1;
		  reset = 1'b0;
		  btn_write = 1'b0;
		  #20000 reset = 1'b1;
		  
		  #380000 reset = 1'b0;
		  #300000 serialIn = 1'b0;
        #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  
		  #20000 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b1;
		  
		  #20000 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  
		  #20000 btn_write = 1'b1;
		  
		  #380000 btn_write = 1'b0;
		   
		  #500000 reset = 1'b1;
		  #380000 reset = 1'b0;

		  #20000 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b1;
		  
		  #20000 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b1;
		  
		  		  		  //b00001000
		  #20000 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;

		  
		  #20000 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b1;
		  
		  #20000 serialIn = 1'b0;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b0;
		  #10416 serialIn = 1'b1;
		  #10416 serialIn = 1'b1;
		  
		  
		  #20000 btn_write = 1'b1;
		  
		  #500000 btn_write = 1'b0;
		  
		  
        #2000000 $finish;
    end

endmodule
