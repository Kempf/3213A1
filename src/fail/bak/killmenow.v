module killmenow (input wire sysclk, input wire sw1, input wire sw2, input wire sw3, input wire sw4, input wire write, input wire auto, output wire out);
    
    // states
    parameter IDLE = 7'b0000000;
    parameter W1L1 = 7'b0000001; // E
    parameter W1L2 = 7'b0000010; // N
    parameter W1L3 = 7'b0000011; // G
    parameter W1L4 = 7'b0000100; // I
    parameter W1L5 = 7'b0000101; // N
    parameter W1L6 = 7'b0000110; // E
    parameter W1L7 = 7'b0000111; // E
    parameter W1L8 = 7'b0001000; // R
    parameter W1L9 = 7'b0001001; // I
    parameter W1L10 = 7'b0001010; // N
    parameter W1L11 = 7'b0001011; // G
    parameter W2L1 = 7'b0001100; // A
    parameter W2L2 = 7'b0001101; // S
    parameter W2L3 = 7'b0001110; // S
    parameter W2L4 = 7'b0001111; // I
    parameter W2L5 = 7'b0010000; // G
    parameter W2L6 = 7'b0010001; // N
    parameter W2L7 = 7'b0010010; // M
    parameter W2L8 = 7'b0010011; // E
    parameter W2L9 = 7'b0010100; // N
    parameter W2L10 = 7'b0010101; // T
    parameter W3L1 = 7'b0011010; // S
    parameter W3L2 = 7'b0011011; // T
    parameter W3L3 = 7'b0011100; // U
    parameter W3L4 = 7'b0011101; // D
    parameter W3L5 = 7'b0011110; // E
    parameter W3L6 = 7'b0011111; // N
    parameter W3L7 = 7'b0100000; // T
    parameter W4L1 = 7'b0100001; // F
    parameter W4L2 = 7'b0100010; // P
    parameter W4L3 = 7'b0100011; // G
    parameter W4L4 = 7'b0100100; // A
    parameter W1SP = 7'b0111111; // _
    parameter W2SP = 7'b0111110; // _
    parameter W3SP = 7'b0111101; // _
    parameter W4SP = 7'b0111100; // _
    parameter O1L1 = 7'b1000001; // E
    parameter O1L2 = 7'b1000010; // N
    parameter O1L3 = 7'b1000011; // G
    parameter O1L4 = 7'b1000100; // I
    parameter O1L5 = 7'b1000101; // N
    parameter O1L6 = 7'b1000110; // E
    parameter O1L7 = 7'b1000111; // E
    parameter O1L8 = 7'b1001000; // R
    parameter O1L9 = 7'b1001001; // I
    parameter O1L10 = 7'b1001010; // N
    parameter O1L11 = 7'b1001011; // G
    parameter O2L1 = 7'b1001100; // A
    parameter O2L2 = 7'b1001101; // S
    parameter O2L3 = 7'b1001110; // S
    parameter O2L4 = 7'b1001111; // I
    parameter O2L5 = 7'b1010000; // G
    parameter O2L6 = 7'b1010001; // N
    parameter O2L7 = 7'b1010010; // M
    parameter O2L8 = 7'b1010011; // E
    parameter O2L9 = 7'b1010100; // N
    parameter O2L10 = 7'b1010101; // T
    parameter O3L1 = 7'b1011010; // S
    parameter O3L2 = 7'b1011011; // T
    parameter O3L3 = 7'b1011100; // U
    parameter O3L4 = 7'b1011101; // D
    parameter O3L5 = 7'b1011110; // E
    parameter O3L6 = 7'b1011111; // N
    parameter O3L7 = 7'b1100000; // T
    parameter O4L1 = 7'b1100001; // F
    parameter O4L2 = 7'b1100010; // P
    parameter O4L3 = 7'b1100011; // G
    parameter O4L4 = 7'b1100100; // A
    parameter O1SP = 7'b1111111; // _
    parameter O2SP = 7'b1111110; // _
    parameter O3SP = 7'b1111101; // _
    parameter O4SP = 7'b1111100; // _
    
    reg [6:0] state = IDLE, next = IDLE;
    
    wire write_deb;
    wire auto_deb;
    wire cereal_ready;
    wire slowclk;
    reg start;
    reg [7:0] data = 8'b00000000;
    
    // inst cereal
    cereal cereal(.sysclk(sysclk),.data(data),.start(start),.cereal(out),.status(cereal_ready));
    
    // slow clock
    clockdiv #(25/*19*/) clockdiv(.sysclk(sysclk),.pulse(slowclk));
    
    // inst debouncers
    debouncer debouncer_w(.sysclk(sysclk),.btn(write),.btn_deb(write_deb));
    debouncer debouncer_a(.sysclk(sysclk),.btn(auto),.btn_deb(auto_deb));
    
    // state memory
    always @(posedge sysclk) state <= next;
    
    // auto mode
    reg auto_on = 1'b0;
    always @(posedge sysclk) begin
        if(auto_deb) begin
            auto_on <= ~auto_on;
        end
    end
    
    // next state
    always @(*) begin
        case(state)
            IDLE: begin
                if (auto_on && slowclk) next = W1L1;
                else if(write_deb) begin
                    if(sw1) next = W1L1;
                    else if(sw2) next = W2L1;
                    else if(sw3) next = W3L1;
                    else if(sw4) next = W4L1;
                    else next = IDLE;
                end
                else next = IDLE;
            end
            O1L11: if(cereal_ready) next = W1SP; else next = O1L11;
            O1SP: if(cereal_ready) begin
                if(sw2) next = W2L1;
                else if(sw3) next = W3L1;
                else if(sw4) next = W4L1;
                else next = IDLE;
            end
            else next = O1SP;
            O2L10: if(cereal_ready) next = W2SP; else next = O2L10;
            O2SP: if(cereal_ready) begin
                if(sw3) next = W3L1;
                else if(sw4) next = W4L1;
                else next = IDLE;
            end
            else next = O2SP;
            O3L7: if(cereal_ready) next = W3SP; else next = O3L7;
            O3SP: if(cereal_ready) begin
                if(sw4) next = W4L1;
                else next = IDLE;
            end
            else next = O3SP;
            O4L4: if(cereal_ready) next = W4SP; else next = O4L4;
            O4SP: if(cereal_ready) next = IDLE; else next = O4SP;
            default: begin
				if(state[6] == 0) begin
					if(!cereal_ready) next = state + 7'b1000000;
					else next = state;
				end
				else begin
					if(cereal_ready) next = state - 7'b0111111;
					else next = state;
				end
			end
        endcase
    end
        
    // output
    always @(state) begin
        case(state)
            IDLE: begin data = 8'b00000000; start = 1'b0; end
            W1L1: begin data = 8'b01000101; start = 1'b1; end // E
            W1L2: begin data = 8'b01001110; start = 1'b1; end // N
            W1L3: begin data = 8'b01000111; start = 1'b1; end // G
            W1L4: begin data = 8'b01001001; start = 1'b1; end // I
            W1L5: begin data = 8'b01001110; start = 1'b1; end // N
            W1L6: begin data = 8'b01000101; start = 1'b1; end // E
            W1L7: begin data = 8'b01000101; start = 1'b1; end // E
            W1L8: begin data = 8'b01010010; start = 1'b1; end // R
            W1L9: begin data = 8'b01001001; start = 1'b1; end // I
            W1L10: begin data = 8'b01001110; start = 1'b1; end // N
            W1L11: begin data = 8'b01000111; start = 1'b1; end // G
            W2L1: begin data = 8'b01000001; start = 1'b1; end // A
            W2L2: begin data = 8'b01010011; start = 1'b1; end // S
            W2L3: begin data = 8'b01010011; start = 1'b1; end // S
            W2L4: begin data = 8'b01001001; start = 1'b1; end // I
            W2L5: begin data = 8'b01000111; start = 1'b1; end // G
            W2L6: begin data = 8'b01001110; start = 1'b1; end // N
            W2L7: begin data = 8'b01001101; start = 1'b1; end // M
            W2L8: begin data = 8'b01000101; start = 1'b1; end // E
            W2L9: begin data = 8'b01001110; start = 1'b1; end // N
            W2L10: begin data = 8'b01010100; start = 1'b1; end // T
            W3L1: begin data = 8'b01010011; start = 1'b1; end // S
            W3L2: begin data = 8'b01010100; start = 1'b1; end // T
            W3L3: begin data = 8'b01010101; start = 1'b1; end // U
            W3L4: begin data = 8'b01000100; start = 1'b1; end // D
            W3L5: begin data = 8'b01000101; start = 1'b1; end // E
            W3L6: begin data = 8'b01001110; start = 1'b1; end // N
            W3L7: begin data = 8'b01010100; start = 1'b1; end // T
            W4L1: begin data = 8'b01000110; start = 1'b1; end // F
            W4L2: begin data = 8'b01010000; start = 1'b1; end // P
            W4L3: begin data = 8'b01000111; start = 1'b1; end // G
            W4L4: begin data = 8'b01000001; start = 1'b1; end // A
            default: begin data = 8'b00100000; start = 1'b1; end // _
        endcase
    end
    
endmodule
