`timescale 100ns / 100ns

module TB_clockdiv;

    wire pulse;
    reg sysclk;


    clockdiv #(15,5207) UUT( 
        .sysclk(sysclk),
        .pulse(pulse)
    );
       
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("clockdiv.vcd");
        $dumpvars;
        #100000; $finish;
    end

endmodule