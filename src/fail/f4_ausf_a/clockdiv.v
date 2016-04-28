module clockdiv (input wire sysclk, output wire pulse);

parameter WIDTH=8;
parameter COUNT=2**WIDTH-1;
reg [(WIDTH-1):0] clockdiv = 0;

assign pulse=!clockdiv;

always @(posedge sysclk) begin
    if (clockdiv == COUNT) 
        clockdiv <= 0;
    else
        clockdiv <= clockdiv + 1;
end

endmodule
