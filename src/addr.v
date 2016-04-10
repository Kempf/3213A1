module addr( 
	input wire [7:0] count,
	input wire sysclk,
	output reg [4:0] addr
    );


	always @(posedge sysclk) begin
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
		else if ((count > 168) && (count < 172)) addr <= 4'b1101;
		else if ((count > 171) && (count < 185)) addr <= 4'b1110;
		else if ((count > 184) && (count < 198)) addr <= 4'b0010;
		else addr = 4'b0000;
	end

endmodule
