`timescale 10ns / 10ns

module tb_fullControlSystem;

	reg sysclk;
	reg sw1;
	reg sw2;
	reg sw3;
	reg sw4;
	reg write;
	reg writeNorth;
	reg auto;
	reg reset;
	reg stateChange;
	reg serialIn;
	wire out_final_really;
	wire [3:0] LEDs;
	wire out_deb1;
	wire out_deb2;

    fullControlSystem UUT( 
			.sysclk(sysclk),
			.reset(reset),
			.serialIn(serialIn),
			.sw1(sw1),
			.sw2(sw2),
			.sw3(sw3),
			.sw4(sw4),
			.write(write),
			.writeNorth(writeNorth),
			.auto(auto),
			.stateChange(stateChange),
			.out_final_really(out_final_really),
			.LEDs(LEDs),
			.out_deb1(out_deb1),
			.out_deb2(out_deb2)
    );
        
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("fullControlSystem.vcd");
        $dumpvars;
		  serialIn = 1'b1;
		  reset = 1'b0;
		  write = 1'b0;
		  writeNorth = 1'b0;
		  #20000 reset = 1'b1;
		  sw1 = 1'b0;
		  sw2 = 1'b0;
		  sw3 = 1'b0;
		  sw4 = 1'b0;
		  stateChange = 1'b0;
		  auto = 1'b0;
		  #380000 reset = 1'b0;
		  #1 stateChange = 1'b1;
		  #600000 stateChange = 1'b0;
		  #100000 stateChange = 1'b1;
		  #600000 stateChange = 1'b0;
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
		  
		  #20000 writeNorth = 1'b1;
		  
		  #380000 writeNorth = 1'b0;
		   
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
		  
		  
		  #20000 writeNorth = 1'b1;
		  
		  #500000 writeNorth = 1'b0;
		  
		  #20000 stateChange = 1'b1;
		  #600000 stateChange = 1'b0;
		  
		  #1000000 sw1 = 1'b1;
		  #1 sw2 = 1'b1;
		  
		  #20000 write = 1'b1;
		  #600000 write = 1'b0;
		  
		  		  #20000 stateChange = 1'b1;
		  #600000 stateChange = 1'b0;
		  
		  #1000000 sw1 = 1'b1;
		  #1 sw2 = 1'b1;
		  
		  #20000 write = 1'b1;
		  #600000 write = 1'b0;
		  
		  
		  
        #2000000 $finish;
    end

endmodule
