`timescale 10ns / 10ns

module tb_switch;

	reg sysclk; 
	 reg sw1;
	 reg sw2; 
	 reg sw3; 
	 reg sw4; 
	 reg write;
	 reg auto;
	 wire out;


    switch UUT( 
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
        $dumpfile("switch.vcd");
        $dumpvars;
        sw1 = 1'b0;
        sw2 = 1'b0;
        sw3 = 1'b0;
        sw4 = 1'b0;
        write = 1'b0;
        #100 sw1 = 1'b1;
        #100 write = 1'b1;
        #400000 write = 1'b0;
        #1800000 write = 1'b1;
        sw1 = 1'b0;
        sw2 = 1'b1;
        #420000 write = 1'b0;
        #100; $finish;
    end

endmodule
