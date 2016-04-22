module d_mux( input wire a1, input wire a2, input wire a3, input wire [7:0] o1, input wire [7:0] o2, input wire [7:0] o3, output reg [7:0] o);

always @(*) begin
	if(a1) o = o1;
	else if (a2) o = o2;
	else o = o3;
end
endmodule
