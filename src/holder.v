module holder (
	input wire write,
	input wire sysclk,
	input wire sw1,
	input wire sw2,
	input wire sw3,
	input wire sw4,
	output reg out);

	reg [8:0] total = 9'b000000000;
	reg [8:0] count = 9'b000000000;
	reg fin = 1'b0;
	reg write_deb;
	
	clockdiv #(15,5207) clockdiv(.sysclk(sysclk),.pulse(pulse));
	
	debouncer debouncer_write(.sysclk(sysclk),.btn(write),.btn_deb(write_deb));
    
    always @(posedge clockdiv) begin
		if ((write_deb == 0)&&(out == 0)) fin = 0;
	 	if ((out == 1)&&(count < total)&&(fin == 0))
			begin
				count <= count + 1;
			end
		else if ((write_deb == 1) && (out == 0) && (fin == 0) && ((sw1==1)||(sw2==1)||(sw3==1)||(sw4==1)))
			begin
				total <= total + (sw1 * 9'b001011000) + (sw2 * 9'b001010000) + (sw3 *  9'b000111000) + (sw4 * 9'b000100000);
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
