`timescale 10ns / 10ns

module TB_cereal;

    reg [7:0] data;
    reg start;
    reg sysclk;
    wire cereal;


    cereal UUT( 
        .sysclk(sysclk),
        .data(data),
        .start(start),
        .cereal(cereal)
    );
       
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("cereal.vcd");
        $dumpvars;
        start = 1'b0;
        data = 8'b00000000;
        #500 data = 8'b01011010;
        #500 start = 1'b1;
        #10000 start = 1'b0;
        #200000; $finish;
    end

endmodule