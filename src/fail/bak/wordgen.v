module wordgen (input wire sysclk, input wire sw1, input wire sw2, input wire sw3, input wire sw4, input wire write, input wire auto, output wire out);

    wire write_deb, auto_deb;
    reg start = 0;
    wire status; //cereal status
    reg [7:0] data;
    reg auto_on = 0;

    parameter W1 = 4'b0000;
    parameter W2 = 4'b0001;
    parameter W3 = 4'b0010;
    parameter W4 = 4'b0100;
    parameter WAIT = 4'b1000;
    
    reg [3:0] state = WAIT;
    reg [3:0] next = WAIT;
    
    reg done = 0;
    reg send = 0;
    reg enable_sendword = 0;
    reg word;
    reg status_sendword;
    
    // inst debouncers
    debouncer debouncer_w(.sysclk(sysclk),.btn(write),.btn_deb(write_deb));
    debouncer debouncer_a(.sysclk(sysclk),.btn(auto),.btn_deb(auto_deb));
    // inst slowclk ~1 s heartbeat
    clockdiv #(25) clockdiv(.sysclk(sysclk),.pulse(slowclk));
    // inst sendword
    sendword sendword (.sysclk(sysclk),.enable(enable_sendword),.word(word),.out(out),.status(status_sendword));
    
    
    // control auto mode
    always @(posedge auto_deb) begin
        if (!auto_on) auto_on = 1;
        else auto_on = 0;
    end
    
    always @(auto_on or write_deb) begin
        if (auto_on || write_deb) send = 1;
        else ;
    end
    
    // next state
    always @(posedge sysclk) state <= next; //was slowclk
    
    // select next state
    always @(*) begin
        case(state)
            WAIT: if(send) begin
                    next <= W1;
                    done = 0;
                end
                else begin next <= WAIT; end
            W1: if(done) begin
                    next <= W2;
                    done = 0;
                end
                else next <= W1; 
            W2: if(done) begin
                    next <= W3;
                    done = 0;
                end
                else next <= W2;
            W3: if(done) begin
                    next <= W4;
                    done = 0;
                end
                else next <= W3;
            W4: if(done) begin
                    if(auto_on) begin
                        next <= W1;
                        done = 0;
                    end
                    else begin
                        next <= WAIT;
                        send = 0;
                    end
                end
                else next <= W4;
        endcase
    end
    
    // output logic
    always @(state) begin
        case(state)
            W1: begin 
                    // control sendword
                end
            W2: begin 
                    
				end
            W3: begin
					
				end
            W4: begin
					
				end
            default: data = 8'b00000000;
        endcase
    end
endmodule
