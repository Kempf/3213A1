module killmenow (input wire sysclk, input wire sw1, input wire sw2, input wire sw3, input wire sw4, input wire write, input wire auto, output wire out);
    
    // states
    parameter IDLE = 6'b000000;
    parameter W1L1 = 6'b000001; // E
    parameter W1L2 = 6'b000010; // N
    parameter W1L3 = 6'b000011; // G
    parameter W1L4 = 6'b000100; // I
    parameter W1L5 = 6'b000101; // N
    parameter W1L6 = 6'b000110; // E
    parameter W1L7 = 6'b000111; // E
    parameter W1L8 = 6'b001000; // R
    parameter W1L9 = 6'b001001; // I
    parameter W1L10 = 6'b001010; // N
    parameter W1L11 = 6'b001011; // G
    parameter W2L1 = 6'b001100; // A
    parameter W2L2 = 6'b001101; // S
    parameter W2L3 = 6'b001110; // S
    parameter W2L4 = 6'b001111; // I
    parameter W2L5 = 6'b010000; // G
    parameter W2L6 = 6'b010001; // N
    parameter W2L7 = 6'b010010; // M
    parameter W2L8 = 6'b010011; // E
    parameter W2L9 = 6'b010100; // N
    parameter W2L10 = 6'b010101; // T
    parameter W3L1 = 6'b011010; // S
    parameter W3L2 = 6'b011011; // T
    parameter W3L3 = 6'b011100; // U
    parameter W3L4 = 6'b011101; // D
    parameter W3L5 = 6'b011110; // E
    parameter W3L6 = 6'b011111; // N
    parameter W3L7 = 6'b100000; // T
    parameter W4L1 = 6'b100001; // F
    parameter W4L2 = 6'b100010; // P
    parameter W4L3 = 6'b100011; // G
    parameter W4L4 = 6'b100100; // A
    parameter W1SP = 6'b111111; // _
    parameter W2SP = 6'b111110; // _
    parameter W3SP = 6'b111101; // _
    parameter W4SP = 6'b111100; // _
    
    reg [5:0] state = IDLE, next = IDLE;
    
    wire write_deb;
    wire auto_deb;
    wire cereal_ready;
    wire pulse;
    wire slowclk;
    reg start;
    reg [7:0] data = 8'b00000000;
    
    // inst cereal
    cereal cereal(.sysclk(sysclk),.data(data),.start(start),.cereal(out),.status(cereal_ready),.pulse(pulse));
    
    // slow clock
    clockdiv #(25/*19*/) clockdiv(.sysclk(sysclk),.pulse(slowclk));
    
    // inst debouncers
    debouncer debouncer_w(.sysclk(sysclk),.btn(write),.btn_deb(write_deb));
    debouncer debouncer_a(.sysclk(sysclk),.btn(auto),.btn_deb(auto_deb));
    
    // state memory
    always @(posedge sysclk) state <= next;
    
    // output latch
    reg latch = 1'b0;
    
    always @(posedge sysclk) begin
        latch <= cereal_ready;
    end
    
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
            W1L11: if(cereal_ready && !latch) next = W1SP; else next = W1L11;
            W1SP: if(cereal_ready && !latch) begin
                if(sw2) next = W2L1;
                else if(sw3) next = W3L1;
                else if(sw4) next = W4L1;
                else next = IDLE;
            end
            else next = W1SP;
            W2L10: if(cereal_ready && !latch) next = W2SP; else next = W2L10;
            W2SP: if(cereal_ready && !latch) begin
                if(sw3) next = W3L1;
                else if(sw4) next = W4L1;
                else next = IDLE;
            end
            else next = W2SP;
            W3L7: if(cereal_ready && !latch) next = W3SP; else next = W3L7;
            W3SP: if(cereal_ready && !latch) begin
                if(sw4) next = W4L1;
                else next = IDLE;
            end
            else next = W3SP;
            W4L4: if(cereal_ready && !latch) next = W4SP; else next = W4L4;
            W4SP: if(cereal_ready && !latch) next = IDLE; else next = W4SP;
            default: if(cereal_ready && !latch) next = state + 6'b000001; else next = state;
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
