module ram(input wire sysclk,
input wire write,
input wire [7:0] addr,
input wire [15:0] data_in,
input wire reset,
output reg [15:0] data_out);

reg [15:0] mem [255:0];
integer i;

always @(posedge sysclk) begin
	if (write) mem[addr] <= data_in;
	data_out<=mem[addr];
	
	if (reset) begin
		for (i = 0; i < 256; i = i+1) begin
			mem[i] <= 16'b0000000000000000;
		end
	end
end

endmodule
