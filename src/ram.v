module ram(input wire sysclk,
input wire write,
input wire [7:0] addr,
input wire [15:0] data_in,
input wire reset,
output reg [15:0] data_out);

reg [15:0] mem [255:0];
reg i = 0;
reg reset_deb;

debouncer debouncer_reset(.sysclk(sysclk),.btn(write),.btn_deb(reset_deb));

always @(posedge sysclk) begin
	if (write) mem[addr] <= data_in;
	data_out<=mem[addr];
	if (reset) begin
		for (i = 0; i < 256; i = i+1) begin
			mem[i] <= 0;
		end
	end
end

endmodule	
