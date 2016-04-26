module fullControlSystem(
	input wire sysclk,
	input wire sw1,
	input wire sw2,
	input wire sw3,
	input wire sw4,
	input wire write,
	input wire writeNorth,
	input wire auto,
	input wire reset,
	input wire stateChange,
	input wire serialIn,
	output wire out_final_really,
	output reg [3:0] LEDs,
	output wire out_deb1,
	output wire out_deb2
    );
	 
	reg active1;
	reg active2;
	reg active3;
	wire stateChange_deb;
	wire [7:0] out1, out2, out3;
	wire start1, start2, start3;
	wire [7:0] data_final;
	wire start_final;
	wire serialOut;
	wire store_latch;
	wire out_final;
	wire pulse;
	
	assign out_deb1 = out_final_really;
	assign out_deb2 = pulse;
	
	 parameter FUNC1 = 3'b000;
    parameter FUNC2 = 3'b001;
    parameter FUNC3 = 3'b010;
	 
	 reg [2:0] state = FUNC1, next = FUNC2;
	 
	debouncer SCdebouncer(.sysclk(sysclk),.btn(stateChange), .btn_deb(stateChange_deb));
	 
	keyboard keyboard(.sysclk(sysclk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .btn(write), .data(out1), .start(start1));
	wordboard wordboard(.active(active2), .sysclk(sysclk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .btn_write(write), .btn_auto(auto), .data(out2), .start_delayed(start2));
	tweetboard tweetboard(.active(active3), .sysclk(sysclk), .reset(reset), .serialIn(serialIn), .btn_write(writeNorth), .data(out3), .start(start3), .out_fin(serialOut), .store_latch(store_latch));
	d_mux d_mux(.a1(active1), .a2(active2), .a3(active3), .o1(out1), .o2(out2), .o3(out3), .o(data_final), .so1(start1), .so2(start2), .so3(start3), .so(start_final));
	cereal cereal(.sysclk(sysclk),.data(data_final),.start(start_final),.cereal(out_final),.pulse(pulse));
	mux mux(.writeOut(out_final), .serialIn(serialOut), .select(store_latch), .out(out_final_really));
	
	
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
					 LEDs <= 3'b001;
            end
            FUNC2: begin
					active1 <= 0;
					active2 <= 1;
					active3 <= 0;
					LEDs <= 3'b010;
            end
            FUNC3: begin 
               active1 <= 0;
					active2 <= 0;
					active3 <= 1;
					LEDs <= 3'b100;
            end
        endcase
    end

endmodule





/*module fullControlSystem(
	input wire sysclk,
	input wire sw1,
	input wire sw2,
	input wire sw3,
	input wire sw4,
	input wire write,
	input wire writeNorth,
	input wire auto,
	input wire reset,
	input wire stateChange,
	input wire serialIn,
	output wire out_final,
	output reg [3:0] LEDs,
	output wire out_deb1,
	output wire out_deb2
    );
	 
	reg active1;
	reg active2;
	reg active3;
	wire stateChange_deb;
	wire out1;
	wire out2;
	wire out3;
	
	assign out_deb1 = out2;
	assign out_deb2 = out3;
	// assign mark = 100;
	
	 parameter FUNC1 = 2'b00;
    parameter FUNC2 = 2'b01;
    parameter FUNC3 = 2'b10;
	 
	 reg [1:0] state = FUNC1;
	 
	debouncer SCdebouncer(.sysclk(sysclk),.btn(stateChange), .btn_deb(stateChange_deb));
	 
	/*keyboard keyboard(.active(active1), .sysclk(sysclk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .btn(write), .out(out1));
	wordboard wordboard(.active(active2), .sysclk(sysclk), .sw1(sw1), .sw2(sw2), .sw3(sw3), .sw4(sw4), .btn_write(write), .btn_auto(auto), .out(out2));
	tweetboard tweetboard(.active(active3), .sysclk(sysclk), .reset(reset), .serialIn(serialIn), .btn_write(writeNorth), .out(out3));
	mux mux(.a1(active1), .a2(active2), .a3(active3), .o1(out1), .o2(out2), .o3(out3), .o(out_final));
	
	 always @(posedge sysclk) begin
		  if (stateChange_deb) begin
			  case(state)
					FUNC1: state <= FUNC2;
					FUNC2: state <= FUNC3;
					FUNC3: state <= FUNC1;
			  endcase
		  end
    end
	 
	always @(*) begin
		case(state)
            FUNC1: begin
                active1 = 1'b1;
					 active2 = 1'b0;
					 active3 = 1'b0;
					 LEDs = 3'b001;
					 //out_final = out1;
            end
            FUNC2: begin
					active1 = 1'b0;
					active2 = 1'b1;
					active3 = 1'b0;
					LEDs = 3'b010;
					//out_final = out2;
            end
            FUNC3: begin 
               active1 = 1'b0;
					active2 = 1'b0;
					active3 = 1'b1;
					LEDs = 3'b100;
					//out_final = out3;
            end
        endcase
	end
	
	//assign out_final = (active1 & out1) | (active2 & out2) | (active3 & out3);
	
endmodule
*/
