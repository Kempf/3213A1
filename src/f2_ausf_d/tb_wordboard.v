`timescale 10ns / 10ns

module TB_wordboard;

    reg sysclk;
    reg sw1, sw2, sw3, sw4;
    reg btn_write, btn_auto;
    wire out;


    wordboard UUT( 
        .sysclk(sysclk),
        .sw1(sw1),
        .sw2(sw2),
        .sw3(sw3),
        .sw4(sw4),
        .btn_write(btn_write),
        .btn_auto(btn_auto),
        .out(out)
    );
       
    // 50 MHz clock
    initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("wordboard.vcd");
        $dumpvars;
        sw1 = 1'b0;
        sw2 = 1'b0;
        sw3 = 1'b0;
        sw4 = 1'b1;
        btn_write = 1'b0;
        #500000 btn_write = 1'b1;
        #400000 btn_write = 1'b0;
        #2000000 sw1 = 1'b1;
        #200 btn_write = 1'b1;
        #400000 btn_write = 1'b0;
        #2000000 $finish;
    end

endmodule