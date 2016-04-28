module mux( input wire writeOut, input wire serialIn, input wire select, output reg out);

always @(*) begin
	if(select) out = serialIn;
	else out = writeOut;
end

endmodule
