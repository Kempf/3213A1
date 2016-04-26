module d_mux( input wire a1, input wire a2, input wire a3, input wire [7:0] o1, input wire [7:0] o2, input wire [7:0] o3, output reg [7:0] o, input wire so1, input wire so2, input wire so3, output reg so);

always @(*) begin
	if(a1) begin o = o1; so = so1; end
	else if (a2) begin o = o2; so = so2; end
	else begin o = o3; so = so3; end
end
endmodule
