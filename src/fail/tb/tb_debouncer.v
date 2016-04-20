`timescale 100ns / 100ns

module TB_debouncer;

    reg btn;
    wire btn_deb;
    reg sysclk;


    debouncer UUT( 
        .sysclk(sysclk),
        .btn(btn),
        .btn_deb(btn_deb)
    );
       
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("debouncer.vcd");
        $dumpvars;
        #1 btn = 1'b0;
        #5 btn = 1'b1;
        #10 btn = 1'b0;
        #200 btn = 1'b1;
        #100000 btn = 1'b0;
        #150000 btn = 1'b1;
        #900000 btn = 1'b0;
        #100000; $finish;
    end

endmodule