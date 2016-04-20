`timescale 10ns / 10ns

module TB_rom2;

    reg sysclk;
    reg [3:0] addr;
    wire [7:0] data;


    rom2 uut( 
        .addr(addr),
        .data(data)
    );
       
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("rom1.vcd");
        $dumpvars;
        addr = 4'b0000;
        #1000 addr = 4'b0001;
        #2000 addr = 4'b0010;
		  #3000 addr = 4'b0011;
        #4000 addr = 4'b0100;
		  #5000 addr = 4'b0101;
        #6000 addr = 4'b0110;
		  #7000 addr = 4'b0111;
        #8000 addr = 4'b1000;
		  #9000 addr = 4'b1001;
        #10000 addr = 4'b1010;
		  #11000 addr = 4'b1011;
        #12000 addr = 4'b1100;
		  #13000 addr = 4'b1101;
        #14000 addr = 4'b1110;
		  #15000 addr = 4'b1111;
		  #1000000; $finish;
    end

endmodule
