module keyboard (input wire sysclk, input wire sw1, input wire sw2, input wire sw3, input wire sw4, input wire btn_write, input wire btn_auto, output wire out, output wire pulse);

	wire btn_deb;
	wire auto_deb;
	reg start; //hold time of 5702 clock cycles
	wire status; //cereal status
	wire [3:0] in;
	wire [7:0] data;
	wire char_pulse;
	reg [5:0] count = 6'b000000;
	reg btn_latch = 1'b0;
	reg [5:0] total = 6'b000000;
	reg [5:0] addr;
		 
	// inst debouncer
	debouncer w_debouncer(.sysclk(sysclk),.btn(btn_write),.btn_deb(btn_deb));
	debouncer a_debouncer(.sysclk(sysclk),.btn(btn_auto),.btn_deb(auto_deb));
	// inst cereal
	cereal cereal(.sysclk(sysclk),.data(data),.start(start),.cereal(out),.status(status),.pulse(pulse));
	// character pulse
	clockdiv #(17,78105) chardiv(.sysclk(sysclk),.pulse(char_pulse));
	// instantiate rom
	rom rom(.addr(addr),.data(data));
	
	// assemble input
	assign in[0] = sw1;
	assign in[1] = sw2;
	assign in[2] = sw3;
	assign in[3] = sw4;

	// set data to send
	
	// send
	always @(posedge sysclk) begin

		case(in)
			4'b0000: begin
				if(btn_deb) total <= 6'b000000;
				addr <= 6'b000000;
			end
			4'b0001: begin
				if(btn_deb) total <= 6'b001100; // 12
				addr <= count;
			end
			4'b0010: begin
				if(btn_deb) total <= 6'b001011; // 11
				addr <= count + 6'b001100;
			end
			4'b0011: begin
				if(btn_deb) total <= 6'b010111; // 23
				addr <= count;
			end
			4'b0100: begin
				if(btn_deb) total <= 6'b001000; // 8
				addr <= count + 6'b010111;
			end
			4'b0101: begin
				if(btn_deb) total <= 6'b010100; // 20
				if(count > 12) addr <= count + 6'b010111;
				else addr <= count;
			end
			4'b0110: begin
				if(btn_deb) total <= 6'b010011; // 19
				addr <= count + 6'b001100;
			end
			4'b0111: begin
				if(btn_deb) total <= 6'b011111; // 31
				addr <= count;
			end
			4'b1000: begin
				if(btn_deb) total <= 6'b000101; // 5
				addr <= count + 6'b011111;
			end
			4'b1001: begin
				if(btn_deb) total <= 6'b010001; // 17
				if(count > 12) addr <= count + 6'b011111;
				else addr <= count;
			end
			4'b1010: begin
				if(btn_deb) total <= 6'b010000; // 16
				if(count > 11) addr <= count + 6'b011111;
				else addr <= count + 6'b001100;
			end
			4'b1011: begin
				if(btn_deb) total <= 6'b011100; // 28
				if (count > 23) addr <= count + 6'b011111;
				else addr <= count;
			end
			4'b1100: begin
				if(btn_deb) total <= 6'b001101; // 13
				addr <= count + 6'b010111;
			end
			4'b1101: begin
				if(btn_deb) total <= 6'b011001; // 25
				if(count > 12) addr <= count + 6'b010111;
				else addr <= count;
			end
			4'b1110: begin
				if(btn_deb) total <= 6'b011000; // 24
				addr <= count + 6'b001100;
			end
			4'b1111: begin
				if(btn_deb) total <= 6'b100100; // 36
				addr <= count;
			end
			default: begin
				total <= 6'b000000;
				addr <= 0;
			end
		endcase

		if(btn_deb) btn_latch <= 1'b1;
		else if (count == total) begin
			btn_latch <= 1'b0;
			count <= 6'b000000;
		end

		if(btn_latch && char_pulse) begin     // start transmission
			start <= 1'b1;
			count <= count + 6'b000001;
		end
		else begin
			start <= 1'b0;
		end
	end
    
endmodule
