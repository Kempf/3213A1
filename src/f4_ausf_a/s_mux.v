module s_mux( input wire a1, input wire a2, input wire a3, input wire o1, input wire o2, input wire o3, output reg o);

always @(*) begin
	if(a1) o = o1;
	else if (a2) o = o2;
	else o = o3;
end

endmodule
