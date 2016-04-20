module sendword (input wire sysclk, input wire enable, input wire [1:0] word, output reg status, output wire out);

    // rom wires
    wire [7:0] d1;
    wire [7:0] d2;
    wire [7:0] d3;
    wire [7:0] d4;
    reg [3:0] a1 = 4'b000;
    reg [3:0] a2 = 4'b000;
    reg [3:0] a3 = 4'b000;
    reg [3:0] a4 = 4'b000;
    
    // rom instances
    rom1 rom1(.data(d1),.addr(a1));
    rom2 rom2(.data(d2),.addr(a2));
    rom3 rom3(.data(d3),.addr(a3));
    rom4 rom4(.data(d4),.addr(a4));
    
    // states
    parameter IDLE = 3'b000;
    parameter SEND = 3'b001;
    parameter WAIT = 3'b010;
    
    reg [2:0] state = IDLE, next = IDLE;
    
    // variables
    reg [3:0] addr = 4'b0000;
    reg word_done = 1'b0;
    wire cereal_ready;
    reg [7:0] data_out = 8'b00000000;
    reg start;
    
    // inst cereal
    cereal cereal(.sysclk(sysclk),.data(data_out),.start(start),.cereal(out),.status(cereal_ready));
    
    // set next state
    always @(posedge sysclk) state <= next;
    
    // next state logic
    always @(*) begin
        case(state)
            IDLE: if(enable) next <= SEND; else next <= IDLE;
            SEND: if(!cereal_ready) next <= WAIT; else if (word_done) next <= IDLE; else next <= SEND;
            WAIT: if (word_done) next <= IDLE; else if(cereal_ready) next <= SEND; else next <= WAIT;
        endcase
    end
    
    always @(posedge sysclk) begin
        case(word)
            2'b00: begin
                a1 <= addr;
                data_out <= d1;
            end
            2'b01: begin
                a2 <= addr;
                data_out <= d2;
            end
            2'b10: begin
                a3 <= addr;
                data_out <= d3;
            end
            2'b11: begin
                a4 <= addr;
                data_out <= d4;
            end
        endcase
    end
    
    // output logic
    always @(state) begin
        case(state)
            IDLE: begin
                data_out <= 8'b00000000;
                start <= 1'b0;
                status <= 1'b1;
                word_done <= 1'b0;
                addr <= 4'b0000;
            end
            SEND: begin
                if (data_out != 8'b000000) begin
                    status <= 1'b0;
                    start <= 1'b1;        
                end
                else begin
                    word_done <= 1'b1;                
                    next <= IDLE;
                end
            end
            WAIT: begin 
                start <= 1'b0;
                addr <= addr + 1'b1;
                
            end
        endcase
    end
    
endmodule
