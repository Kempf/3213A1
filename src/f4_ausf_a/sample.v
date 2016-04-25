module sample (input wire sysclk, input wire enable, output reg pulse);

reg [14:0] count = 0;

always @(posedge sysclk) begin
    if(enable) begin
        if (count == 2603)
            pulse <= 1;
        else
            pulse <= 0;
        if (count == 5207) 
            count <= 0;
        else
            count <= count + 1;
    end
    else begin
        count <= 0;
        pulse <= 0;
    end
end

endmodule
