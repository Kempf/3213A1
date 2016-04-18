module control_f3 (input wire sysclk, input wire reset, input wire send, input wire serialIn, output wire out_fin);

	wire serialToRAM;
	wire [7:0] addr;
	wire [15:0] data_in;
	wire [15:0] data_out;
	wire send_latch;
	wire write;

   ram ram(.sysclk(sysclk), .write(write), .addr(addr), .data_in(data_in), .reset(reset), .data_out(data_out));    
	dataControlModule dataControlModule(,clk(clk), .sysclk(sysclk), .serialIn(serialIn), .reset(reset), .send(send), .write(write), .addr(addr), .serialToRAM(serialToRAM), .start_latch(send_latch));	
	cereal cereal(.sysclk(sysclk),.data(data_out),.start(send_latch),.cereal(out_fin),.status(),.pulse(), .data_latch()); // Finish hooking this up
	 
endmodule
