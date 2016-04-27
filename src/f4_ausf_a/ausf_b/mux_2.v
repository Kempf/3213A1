module mux_2( input wire writeOut, input wire underLimit, input wire serialIn, input wire select, output reg out);

always @(*) begin
	if(select && underLimit) out = serialIn;
	else out = writeOut;
end

endmodule
