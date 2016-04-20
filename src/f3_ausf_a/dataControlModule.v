// This module will receive the data from the computer, and send it to the RAM.
// TIming will need to change, dependent on how the computer actually transmits data.

module dataControlModule(
	input wire clk,
	input wire sysclk,
	input wire serialIn,
	input wire reset,
	input wire send,
	output reg write,
	output reg [7:0] addr,
	output reg [15:0] serialToRAM,
	output reg send_latch
    );
	 
	reg trigger = 0;
	reg count = 0;
	reg start = 0;
	reg storedWords = 0;
	reg sentWords = 0;
	//assign addr = storedWords;
	reg statue = 0;
	reg count13 = 0;
	reg addrChanger = 0; //If 0, it is in receiving mode. If 1, it is sending mode.
	 
	 
always @(posedge sysclk) begin
	if (trigger == 1) start <= 1; 
	if (send == 1) send_latch <= 1;
	if (send_latch && (sentWords == storedWords)) send_latch <= 0;
end
	 
always @(posedge clk) begin
	if (reset) begin
		count <= 0;
		start <= 0;
		write <= 0;
		storedWords <= 0;
		addrChanger <= 0;
	end
	else if (send_latch == 0)  begin
		addrChanger <= 0;
		if (trigger == 1)  begin
			start <= 1;
		end
		else if(start) begin
			if (count < 8) begin
				serialToRAM[count] <= serialIn;
				count <= count + 1;
				end
			else	begin
			count <= 0;
			start <= 0;
			write <= 1;
			storedWords <= storedWords + 1;
			end
		end
		else begin
			count <= 0;
			start <= 0;
			write <= 0;
		end
	end
	else if (send_latch == 1) begin
		addrChanger <= 1;
		write <= 0;
		if (count13 < 12) count13 <= count13 + 1;
		if (count13 == 12) begin
			count13 <= 0;
			storedWords <= storedWords + 1;
		end
	end
	
	if (addrChanger) addr <= sentWords;
	else addr <= storedWords;
	
end
	 

endmodule
