`timescale 10ns / 10ns

module tb_killmenow;

	reg sysclk; 
	reg sw1;
	reg sw2; 
	reg sw3; 
	reg sw4; 
	reg write;
	reg auto;
	wire out;


    killmenow UUT( 
        .sysclk(sysclk),
        .sw1(sw1),
        .sw2(sw2),
        .sw3(sw3),
        .sw4(sw4),
        .write(write),
        .auto(auto),
		.out(out)
    );
       
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("killmenow.vcd");
        $dumpvars;
        sw1 = 1'b1;
        sw2 = 1'b1;
        sw3 = 1'b1;
        sw4 = 1'b1;
        auto = 1'b0;
        write = 1'b0;
        #100 auto = 1'b1;
        #400000 auto = 1'b0;
        #10000000 $finish;
    end

endmodule
