`timescale 10ns / 10ns

module tb_holder;

	reg sysclk; 
	 reg sw1;
	 reg sw2; 
	 reg sw3; 
	 reg sw4; 
	 reg write;
	 wire out;


    holder UUT( 
        .sysclk(sysclk),
        .sw1(sw1),
        .sw2(sw2),
        .sw3(sw3),
        .sw4(sw4),
        .write(write),
		  .out(out)
    );
       
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("wordgen.vcd");
        $dumpvars;
        sw1 = 1'b0;
        sw2 = 1'b0;
        sw3 = 1'b0;
        sw4 = 1'b0;
        write = 1'b0;
        #1000 sw1 = 1'b1;
        #5000 sw1 = 1'b0;
        #6000 write = 1'b1;
        #407000 write = 1'b0;
        #410000 sw1 = 1'b1;
        #415000 write = 1'b1;
        #820000 write = 1'b0;
        #825000 sw1 = 1'b1;
        #830000 sw1 = 1'b1;
        #830000 sw2 = 1'b1;
        #830000 sw3 = 1'b1;
        #832000 write = 1'b1;
        #1235000 write = 1'b0;
        #1240000 sw4 = 1'b1;
        #1245000 write = 1'b1;
        #1850000 sw1 = 1'b0;
        #1850000 sw2 = 1'b0;
        #1850000 sw3 = 1'b0;
        #1850000 sw4 = 1'b0;
        #1870000 write = 1'b0;
        #2000000; $finish;
    end

endmodule
