module holder (
	input wire write,
	input wire auto,
	input wire sysclk,
	input wire sw1,
	input wire sw2,
	input wire sw3,
	input wire sw4,
	output reg sw1_latch,
	output reg sw2_latch,
	output reg sw3_latch,
	output reg sw4_latch,
	output reg auto_latch,
	output reg out,
	output wire clk,
	output reg outTrig);

	reg [8:0] total = 9'b000000000;
	wire write_deb;
	reg deb = 1'b0;
	reg [8:0] count = 9'b000000000;
	reg latch = 1'b0;
	wire auto_deb;
	reg [9:0] cycle_len = 9'b000000000;
		
	clockdiv #(15,5207) clockdiv(.sysclk(sysclk),.pulse(clk));
	
	debouncer debouncer_write(.sysclk(sysclk),.btn(write),.btn_deb(write_deb));
	debouncer debouncer_auto(.sysclk(sysclk),.btn(auto),.btn_deb(auto_deb));
	
	always @(posedge sysclk) begin
		if (write_deb == 1) deb <= 1;							//Locks a value at sysclk freq
		if ((count > 0) && (count == total)) deb <= 0;
		outTrig = (auto_latch || out);
	end
	
	always @(posedge auto_deb) begin
	if (out == 0)
		begin
			if (auto_latch !== 1) 
				begin
					auto_latch <= 1;
					//cycle_len <= (sw1 * 131) + (sw2 * 120) + (sw3 * 87) + (sw4 * 54);
					if (sw1 == 1) sw1_latch <= 1;
					if (sw2 == 1) sw2_latch <= 1;
					if (sw3 == 1) sw3_latch <= 1;
					if (sw4 == 1) sw4_latch <= 1;
				end
			else 
				begin
					auto_latch <= 0;
					//cycle_len <= 0;
					sw1_latch <= 0;
					sw2_latch <= 0;
					sw3_latch <= 0;
					sw4_latch <= 0;
				end
		end
	else 
		begin
			auto_latch <= 0;
			//cycle_len <= 0;
			sw1_latch <= 0;
			sw2_latch <= 0;
			sw3_latch <= 0;
			sw4_latch <= 0;
		end		
	end
	
    always @(posedge clk) begin
		begin		
			if ((out == 1)&&(count < total))
				begin
					count <= count + 1;
				end
			else if ((out == 1)&&(count == total))					
				begin
					out <= 0;
					count <= 9'b000000000;
					latch <= 0;
				end
			else if (deb == 1 && ((sw1==1)||(sw2==1)||(sw3==1)||(sw4==1))) 
				begin
					out <= 1;	
					total <= (sw1 * 131) + (sw2 * 120) + (sw3 * 87) + (sw4 * 54);
				end
			else
				begin
					out <= 0;
					count <= 9'b000000000;
					latch <= 0;
				end
			end
		end
endmodule
