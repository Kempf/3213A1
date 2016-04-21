module fullControlSystem(
	input wire sysclk,
	input wire sw1,
	input wire sw2,
	input wire sw3,
	input wire sw4,
	input wire write,
	input wire auto,
	input wire reset,
	input wire stateChange,
	input wire serialIn,
	output reg out_final,
	output reg [2:0] LEDs
    );
	 
	reg active1;
	reg active2;
	reg active3;
	wire stateChange_deb;
	wire out1;
	wire out2;
	wire out3;
	
	 parameter FUNC1 = 3'b000;
    parameter FUNC2 = 3'b001;
    parameter FUNC3 = 3'b010;
	 
	 reg [2:0] state = FUNC1, next = FUNC2;
	 
	debouncer SCdebouncer(.sysclk(sysclk),.btn(stateChange), .btn_deb(stateChange_deb));
	 
	keyboard keyboard(.active(active1), .sysclk(sysclk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .btn(write), .out(out1));
	wordboard wordboard(.active(active2), .sysclk(sysclk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .btn_write(write), .btn_auto(auto), .out(out2));
	tweetboard tweetboard(.active(active3), .sysclk(sysclk), .reset(reset), .serialIn(serialIn), .btn_write(write), .out(out3));

	always @(posedge sysclk) begin
		if (stateChange_deb) state <= next;
	end
	
	
    always @(*) begin
        case(state)
            FUNC1: next <= FUNC2; 
            FUNC2: next <= FUNC3; 
            FUNC3: next <= FUNC1; 
        endcase
    end
	 
	 always @(state) begin
        case(state)
            FUNC1: begin
                active1 <= 1;
					 active2 <= 0;
					 active3 <= 0;
					 out_final <= out1;
					 LEDs <= 3'b001;
            end
            FUNC2: begin
					active1 <= 0;
					active2 <= 1;
					active3 <= 0;
					out_final <= out2;
					LEDs <= 3'b010;
            end
            FUNC3: begin 
               active1 <= 0;
					active2 <= 0;
					active3 <= 1;
					out_final <= out3;
					LEDs <= 3'b100;
            end
        endcase
    end

endmodule
