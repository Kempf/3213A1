module addr( 
	input wire clk,
	input wire [7:0] count,
	output reg [3:0] addr
    );

	always @(posedge clk) begin
		if (count < 10) addr <= 4'b0000;
		else if ((count > 9) && (count < 21)) addr <= 4'b0001;
		else if ((count > 20) && (count < 32)) addr <= 4'b0010;
		else if ((count > 31) && (count < 43)) addr <= 4'b0011;
		else if ((count > 42) && (count < 54)) addr <= 4'b0100;
		else if ((count > 53) && (count < 65)) addr <= 4'b0101;
		else if ((count > 64) && (count < 76)) addr <= 4'b0110;
		else if ((count > 75) && (count < 87)) addr <= 4'b0111;
		else if ((count > 86) && (count < 98)) addr <= 4'b1000;
		else if ((count > 97) && (count < 109)) addr <= 4'b1001;
		else if ((count > 108) && (count < 120)) addr <= 4'b1010;
		else if ((count > 119) && (count < 131)) addr <= 4'b1011;
		else if ((count > 130) && (count < 142)) addr <= 4'b1100;
		else if ((count > 141) && (count < 153)) addr <= 4'b1101;
		else if ((count > 152) && (count < 164)) addr <= 4'b1110;
		else if ((count > 163) && (count < 175)) addr <= 4'b0010;
		else addr <= 4'b0000;
	end



/*	always @(posedge clk) begin
		if (count < 11) addr <= 4'b0000;
		else if ((count > 10) && (count < 22)) addr <= 4'b0001;
		else if ((count > 21) && (count < 33)) addr <= 4'b0010;
		else if ((count > 32) && (count < 44)) addr <= 4'b0011;
		else if ((count > 43) && (count < 55)) addr <= 4'b0100;
		else if ((count > 54) && (count < 66)) addr <= 4'b0101;
		else if ((count > 65) && (count < 77)) addr <= 4'b0110;
		else if ((count > 76) && (count < 88)) addr <= 4'b0111;
		else if ((count > 87) && (count < 99)) addr <= 4'b1000;
		else if ((count > 98) && (count < 110)) addr <= 4'b1001;
		else if ((count > 109) && (count < 121)) addr <= 4'b1010;
		else if ((count > 120) && (count < 132)) addr <= 4'b1011;
		else if ((count > 131) && (count < 143)) addr <= 4'b1100;
		else if ((count > 142) && (count < 154)) addr <= 4'b1101;
		else if ((count > 153) && (count < 165)) addr <= 4'b1110;
		else if ((count > 164) && (count < 176)) addr <= 4'b0010;
		else addr <= 4'b0000;
	end*/

endmodule
