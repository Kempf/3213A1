module wordboard (input wire sysclk, input wire sw1, input wire sw2, input wire sw3, input wire sw4, input wire btn_write, input wire btn_auto, output wire out);

	wire btn_deb;                   // debounced inputs
	wire auto_deb;
    reg auto_on = 1'b0;             // auto mode on/off
	reg start;                      // cereal start trigger
	wire [3:0] in;                  // switches go here
	wire [7:0] data;                // ASCII goes here
	wire char_pulse;                // heartbeat for outputing characters
    wire slowclk;                   // heartbeat for outputing words in auto mode
	reg [5:0] count = 6'b000000;    // character count
	reg btn_latch = 1'b0;           // write button latch
	reg [5:0] total = 6'b000000;    // total character count
	reg [5:0] addr;                 // ROM address
    reg [1:0] delay;                // flip-flop for delaying things
    reg start_delayed;
    
	// inst debouncer
	debouncer w_debouncer(.sysclk(sysclk),.btn(btn_write),.btn_deb(btn_deb));
	debouncer a_debouncer(.sysclk(sysclk),.btn(btn_auto),.btn_deb(auto_deb));
	// inst cereal
	cereal cereal(.sysclk(sysclk),.data(data),.start(start_delayed),.cereal(out));
	// character pulse
	clockdiv #(17,78105) chardiv(.sysclk(sysclk),.pulse(char_pulse));
    // slow clock
    //clockdiv #(19) clockdiv(.sysclk(sysclk),.pulse(slowclk)); // for TB
	 clockdiv #(25) clockdiv(.sysclk(sysclk),.pulse(slowclk));	// for IRL
	// instantiate rom
	rom rom(.addr(addr),.data(data));
	
    // assemble input
	assign in[0] = sw1;
	assign in[1] = sw2;
	assign in[2] = sw3;
	assign in[3] = sw4;
	
	// send
	always @(posedge sysclk) begin
        // turn auto output on/off
        if(auto_deb) auto_on <= ~auto_on;
        // set char counts addr for ROM
		case(in)
			4'b0000: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b000000;
				addr <= 6'b000000;
			end
			4'b0001: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b001101; // 13
				addr <= count;
			end
			4'b0010: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b001011; // 11
				addr <= count + 6'b001100;
			end
			4'b0011: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b011000; // 24
				addr <= count;
			end
			4'b0100: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b001000; // 8
				addr <= count + 6'b010111;
			end
			4'b0101: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b010101; // 21
				if(count > 12) addr <= count + 6'b001011; // + 11
				else addr <= count;
			end
			4'b0110: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b010011; // 19
				addr <= count + 6'b001100;
			end
			4'b0111: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b100000; // 32
				addr <= count;
			end
			4'b1000: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b000101; // 5
				addr <= count + 6'b011111;
			end
			4'b1001: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b010010; // 18
				if(count > 12) addr <= count + 6'b010011; // + 19
				else addr <= count;
			end
			4'b1010: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b010000; // 16
				if(count > 11) addr <= count + 6'b001000; // + 8
				else addr <= count + 6'b001100;
			end
			4'b1011: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b011101; // 29
				if (count > 23) addr <= count + 6'b001000; // + 8
				else addr <= count;
			end
			4'b1100: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b001101; // 13
				addr <= count + 6'b010111;
			end
			4'b1101: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b011010; // 26
				if(count > 12) addr <= count + 6'b001011; // + 11
				else addr <= count;
			end
			4'b1110: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b011000; // 24
				addr <= count + 6'b001100;
			end
			4'b1111: begin
				if(btn_deb || (slowclk && auto_on)) total <= 6'b100101; // 37
				addr <= count;
			end
			default: begin
				total <= 6'b000000;
				addr <= 0;
			end
		endcase
        
		if(btn_deb || (slowclk && auto_on)) btn_latch <= 1'b1;
		else if (count == total) begin
			btn_latch <= 1'b0;
			count <= 6'b000000;
		end

		if(btn_latch && char_pulse) begin
            count <= count + 6'b000001; // next letter
            start <= 1'b1; // start transmission
        end
        else start <= 1'b0;
        
        // delay start signal
        delay[0] <= start;
        delay[1] <= delay[0];
        start_delayed <= delay[1];
	end
endmodule
