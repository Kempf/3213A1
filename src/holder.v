module holder (
	input wire write,
	input wire auto,
	input wire sysclk,
	input wire sw1,
	input wire sw2,
	input wire sw3,
	input wire sw4,
	output reg out,
	output wire clk,
	output reg forCereal);

	reg [8:0] total = 9'b000000000;
	reg fin = 1'b0;
	wire write_deb;
	reg deb = 1'b0;
	reg [8:0] count = 9'b000000000;
	reg latch = 1'b0;
	reg switchIns = 4'b0000;
	wire auto_deb;
	reg auto_latch;
	reg [9:0] cycle_len = 9'b000000000;
	
	clockdiv #(15,5207) clockdiv(.sysclk(sysclk),.pulse(clk));
	
	debouncer debouncer_write(.sysclk(sysclk),.btn(write),.btn_deb(write_deb));
	debouncer debouncer_auto(.sysclk(sysclk),.btn(auto),.btn_deb(auto_deb));
	
	always @(posedge sysclk) begin
		if (write_deb == 1) deb <= 1;							//Locks a value at sysclk freq
		if ((write == 0) && (fin == 0)) deb <= 0;			// Resets the value if the system is finished writing
		if (auto_deb == 1) begin
			if ((out == 0) && (auto_latch == 0)) begin
				auto_latch <= 1;
				switchIns <= (sw1 * 1) + (sw2 * 2) + (sw3 * 4) + (sw4 * 8);
				cycle_len <= (sw1 * 131) + (sw2 * 120) + (sw3 * 87) + (sw4 * 54);
			end
			else begin
				auto_latch <= 0;
				switchIns = 0;
				cycle_len = 0;
			end
		end	
	end

    always @(posedge clk) begin
		if(auto == 0) 
		begin 
			if (out == 1) forCereal = 1;
			else forCereal = 0;
			if (deb == 1 && ((sw1==1)||(sw2==1)||(sw3==1)||(sw4==1))) latch <= 1;								// Creates a local latch from the debounced value
			if ((write == 0)&&(out == 0)) fin <= 0;			// Resents the finished value when everything is done
			if ((out == 1)&&(count < total)&&(fin == 0))
				begin
					count <= count + 1;
				end
			else if ((latch == 1) && (out == 0) && (fin == 0) && ((sw1==1)||(sw2==1)||(sw3==1)||(sw4==1)))
				begin
					total <= (sw1 * 131) + (sw2 * 120) + (sw3 * 87) + (sw4 * 54); //Currently increased by 1
	/*				if (sw1 == 1) total <= total + 143;
					if (sw2 == 1) total <= total + 130;
					if (sw3 == 1) total <= total + 91;
					if (sw4 == 1) total <= total + 52;*/
					out <= 1;
				end
			else if ((out == 1)&&(count == total))					
				begin
					fin <= 1;
					out <= 0;
					count <= 9'b000000000;
					total <= 9'b000000000;
					latch <= 0;
				end
			else 
				begin
					out <= 0;
					count <= 9'b000000000;
					total <= 9'b000000000;
				end
		end
		else 
			//auto modeeeee
			out <= 1;
		end
endmodule
