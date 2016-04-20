module control (input wire sysclk, input wire write, input wire reset, input wire auto, input wire sw1, input wire sw2, input wire sw3, input wire sw4, output wire out_fin, output wire [7:0] data_latch, output wire out_debug);

	wire holderOut;
	wire holderAutoLatch;
	wire [7:0] currentData;
	wire [3:0] addr;
	wire [7:0] d1;
	wire [7:0] d2;
	wire [7:0] d3;
	wire [7:0] d4;
	wire [9:0] count;
	wire clk;
	wire sw1_latch;
	wire sw2_latch;
	wire sw3_latch;
	wire sw4_latch;
	wire trig;
	assign out_debug = out_fin;
	
    // rom instances
    rom1 rom1(.data(d1),.addr(addr));
    rom2 rom2(.data(d2),.addr(addr));
    rom3 rom3(.data(d3),.addr(addr));
    rom4 rom4(.data(d4),.addr(addr));
    
	holder holder(.sysclk(sysclk), .write(write), .auto(auto), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .sw1_latch(sw1_latch), .sw2_latch(sw2_latch), .reset(reset), .sw3_latch(sw3_latch), .sw4_latch(sw4_latch), .out(holderOut), .auto_latch(holderAutoLatch), .clk(clk));
	
	splitter splitter(.reset(reset), .sysclk(sysclk), .outTrig(trig), .clk(clk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .sw1_latch(sw1_latch), .sw2_latch(sw2_latch), .sw3_latch(sw3_latch), .sw4_latch(sw4_latch), .holder(holderOut), .auto_latch(holderAutoLatch), .rom1(d1), .rom2(d2), .rom3(d3), .rom4(d4), .currentData(currentData), .count(count));
	
	addr addr1(.clk(clk), .count(count), .addr(addr));
	
	cereal cereal(.sysclk(sysclk),.data(currentData),.start(trig),.cereal(out_fin),.status(),.pulse());
	 

	
	
endmodule
