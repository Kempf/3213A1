module ram(input wire sysclk,
input wire write,
input wire [7:0] addr,
input wire [15:0] data_in,
output reg [15:0] data_out);

reg [15:0] mem [255:0];

always @(posedge sysclk) begin
	if (write) mem[addr] <= data_in;
	data_out<=mem[addr];
end

endmodule
