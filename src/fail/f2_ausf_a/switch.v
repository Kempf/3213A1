module switch (input wire sysclk, input wire sw1, input wire sw2, input wire sw3, input wire sw4, input wire write, input wire auto, output wire out);

    wire write_deb, auto_deb;
    
    reg enable_sendword = 0;
    reg [1:0] word;
    wire status_sendword;
    
    // inst debouncers
    debouncer debouncer_w(.sysclk(sysclk),.btn(write),.btn_deb(write_deb));
    debouncer debouncer_a(.sysclk(sysclk),.btn(auto),.btn_deb(auto_deb));
    // inst slowclk ~1 s heartbeat
    clockdiv #(25) clockdiv(.sysclk(sysclk),.pulse(slowclk));
    // inst sendword
    sendword sendword (.sysclk(sysclk),.enable(enable_sendword),.word(word),.out(out),.status(status_sendword));
    
    always @(sw1, sw2, sw3, sw4) begin
        if(sw1) word = 2'b00;
        if(sw2) word = 2'b01;
        if(sw3) word = 2'b10;
        if(sw4) word = 2'b11;
    end
    
    always @(posedge sysclk) begin
        if(write_deb && status_sendword) enable_sendword <= 1'b1;
        else enable_sendword <= 1'b0;
    end
    
endmodule
