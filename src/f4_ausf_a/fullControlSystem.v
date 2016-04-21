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
	input wire serial_In,
	output wire out,
	output reg [2:0] LEDs
    );
	 
	reg active1;
	reg active2;
	reg active3;
	wire stateChange_deb;
	wire stateChange_ff;
	
	 parameter FUNC1 = 3'b000;
    parameter FUNC2 = 3'b001;
    parameter FUNC3 = 3'b010;
	 
	debouncer SCdebouncer(.sysclk(sysclk),.btn(stateChange), .btn_deb(stateChange_deb));
	 
	keyboard keyboard(.active(active1), .sysclk(sysclk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .btn(write), .out(out));
	wordboard wordboard(.active(active2), .sysclk(sysclk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .btn_write(write), .btn_auto(auto), .out(out));
	tweetboard tweetboard(.active(active3), .sysclk(sysclk), .reset(reset), .serialIn(serialIn), .btn_write(write), .out(out));

	always @(posedge sysclk) begin
		if (stateChange_deb) stateChange_ff <= 1;
		else if (stateChange_ff) stateChange_ff <= 0;
	end
	
	
    always @(*) begin
        case(state)
            FUNC1: if(stateChange_ff) next <= FUNC2; 
            FUNC2: if(stateChange_ff) next <= FUNC3; 
            FUNC3: if(stateChange_ff) next <= FUNC1; 
        endcase
    end
	 
	 always @(state) begin
        case(state)
            FUNC1: begin
                active1 <= 1;
					 active2 <= 0;
					 active3 <= 0;
            end
            FUNC2: begin
					active1 <= 0;
					active2 <= 1;
					active3 <= 0;
            end
            FUNC3: begin 
               active1 <= 0;
					active2 <= 0;
					active3 <= 1;
            end
        endcase
    end

endmodule

