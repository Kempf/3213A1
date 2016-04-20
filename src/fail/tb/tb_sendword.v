`timescale 10ns / 10ns

module tb_sendword;

	reg sysclk; 
	reg enable = 1'b0;
    reg [1:0] word = 2'b00;
    wire status;
    wire out;


    sendword UUT( 
        .sysclk(sysclk),
        .enable(enable),
        .word(word),
        .status(status),
        .out(out)
    );
       
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("sendword.vcd");
        $dumpvars;
    end
    
    initial begin
        #100 word = 2'b00;
        #100 enable = 1'b1;
        #200 enable = 1'b0;
        #1500000 word = 2'b01;
        #500 enable = 1'b1;
        #200 enable = 1'b0;
        #1000000 $finish;
    end

endmodule
