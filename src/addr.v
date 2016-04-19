module addr( 
	input wire clk,
	input wire [7:0] count,
	output reg [3:0] addr,
	output reg outTrig
    );

	always @(posedge clk) begin
		if (count == 1) outTrig <= 1;
		else outTrig <= 0;
	
		if (count < 13) addr <= 4'b0000;
		else if ((count > 12) && (count < 26)) addr <= 4'b0001;
		else if ((count > 25) && (count < 39)) addr <= 4'b0010;
		else if ((count > 38) && (count < 52)) addr <= 4'b0011;
		else if ((count > 51) && (count < 65)) addr <= 4'b0100;
		else if ((count > 64) && (count < 78)) addr <= 4'b0101;
		else if ((count > 77) && (count < 91)) addr <= 4'b0110;
		else if ((count > 90) && (count < 104)) addr <= 4'b0111;
		else if ((count > 103) && (count < 117)) addr <= 4'b1000;
		else if ((count > 116) && (count < 130)) addr <= 4'b1001;
		else if ((count > 129) && (count < 143)) addr <= 4'b1010;
		else if ((count > 142) && (count < 156)) addr <= 4'b1011;
		else if ((count > 155) && (count < 169)) addr <= 4'b1100;
		else if ((count > 168) && (count < 182)) addr <= 4'b1101;
		else if ((count > 181) && (count < 195)) addr <= 4'b1110;
		else if ((count > 194) && (count < 208)) addr <= 4'b0010;
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
