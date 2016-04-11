module holder (
	input wire write,
	input wire sysclk,
	input wire sw1,
	input wire sw2,
	input wire sw3,
	input wire sw4,
	output reg out,
	output wire clk);

	reg [8:0] total = 9'b000000000;
	reg fin = 1'b0;
	wire write_deb;
	reg deb = 1'b0;
	reg [7:0] count = 9'b000000000;
	
	clockdiv #(15,5207) clockdiv(.sysclk(sysclk),.pulse(clk));
	
	debouncer debouncer_write(.sysclk(sysclk),.btn(write),.btn_deb(write_deb));
	
	always @(posedge sysclk) begin
		if (write_deb == 1) deb <= 1;
		if ((write == 0) && (fin == 1)) deb <= 0;
	end

    always @(posedge clk) begin
		if ((deb == 0)&&(out == 0)) fin <= 0;
	 	if ((out == 1)&&(count < total)&&(fin == 0))
			begin
				count <= count + 1;
			end
		else if ((deb == 1) && (out == 0) && (fin == 0) && ((sw1==1)||(sw2==1)||(sw3==1)||(sw4==1)))
			begin
				if (sw1 == 1) total <= total + 143;
				if (sw2 == 1) total <= total + 130;
				if (sw3 == 1) total <= total + 91;
				if (sw4 == 1) total <= total + 52;
				out <= 1;
			end
		else if ((out == 1)&&(count == total))					
			begin
				fin <= 1;
				out <= 0;
				count <= 9'b000000000;
				total <= 9'b000000000;
			end
		else 
			begin
				out <= 0;
				count <= 9'b000000000;
				total <= 9'b000000000;
			end
		end
endmodule
