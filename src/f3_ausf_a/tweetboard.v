module tweetboard (input wire sysclk, input wire reset, input wire serialIn, input wire btn_write, output wire out, output wire in_debug, output wire out_debug);

	wire btn_deb;                   // debounced inputs
	wire reset_deb;
	reg start;                      // cereal start trigger
	reg [7:0] data;                // ASCII goes here
	wire pulse;
	wire writePulse;
	
	reg btn_latch = 1'b0;           // write button latch
	reg [7:0] addr;                 // ROM address

	reg [3:0] counter;
	wire [15:0] ramIn; // (͡° ͜ʖ ͡°)
	reg [15:0] toRam;
	reg store_latch;
	reg trigger;
	reg reset_latch = 1'b0;
	
	// please stop looking, it may break the code
	
	assign in_debug = serialIn;
	assign out_debug = out;
    
	// inst debouncer
	debouncer w_debouncer(.sysclk(sysclk),.btn(btn_write), .btn_deb(btn_deb));
	debouncer r_debouncer(.sysclk(sysclk),.btn(reset), .btn_deb(reset_deb));
	// inst cereal
	cereal cereal(.sysclk(sysclk),.data(data),.start(start),.cereal(out),.pulse(pulse));
	// 10 serial bit pulse
	clockdiv #(17,52070) writeDiv(.sysclk(sysclk),.pulse(writePulse));
	// instantiate ram
	ram ram(.sysclk(sysclk), .write(trigger), .addr(addr), .data_in(toRam), .data_out(ramIn));
	
	// send
	always @(posedge sysclk) begin  
		if (reset_latch) begin
				addr <= addr + 1;
				trigger <= 1;
				toRam <= 16'b0000000000000000;
			if (addr == 255) begin
				reset_latch <= 0;
				addr <= 0;
			end
		end
		if (reset_deb) begin
			reset_latch <= 1;
			addr <= 0;
			btn_latch <= 0;
			toRam <= 16'b0000000000000000;
			counter <= 4'b0000;
			store_latch <= 0;
			start <= 0;
		end else		
		begin
			if (pulse && store_latch) counter <= counter + 1;
			if (counter == 4'b1011) begin
				store_latch <= 1'b0;
			end

			if ((serialIn == 0) && (store_latch == 0)) begin 
				store_latch <= 1'b1;
				toRam[15] <= 1;
				counter <= 1;
			end
			
			if (btn_latch && writePulse) begin
				if (ramIn[15] == 0) begin
					btn_latch <= 0;
					start <= 1'b0;
				end
			end
			
			if(btn_latch && writePulse && (ramIn[15]==1)) begin
				addr <= addr + 8'b00000001; // next letter
				data <= ramIn[7:0];
				start <= 1'b1; // start transmission
			end
			
			if (btn_deb && ~store_latch) begin
				btn_latch <= 1;
				addr <= 4'b0000;
			end
		
			if (store_latch) begin
				case (counter) 
				4'b0010: begin toRam[0] <= serialIn; data[0] <= serialIn; toRam[15] <= 1; end
				4'b0011: begin toRam[1] <= serialIn; data[1] <= serialIn; end
				4'b0100: begin toRam[2] <= serialIn; data[2] <= serialIn; end
				4'b0101: begin toRam[3] <= serialIn; data[3] <= serialIn; end
				4'b0110: begin toRam[4] <= serialIn; data[4] <= serialIn; end
				4'b0111: begin toRam[5] <= serialIn; data[5] <= serialIn; end
				4'b1000: begin toRam[6] <= serialIn; data[6] <= serialIn; end
				4'b1001: begin toRam[7] <= serialIn; data[7] <= serialIn; end
				4'b1010: begin trigger <= 1; start <= 1; end
				4'b1011: begin addr <= addr + 1; toRam <= 16'b0000000000000000; trigger <= 0; start <= 0; data <= 8'b00000000; counter <= 4'b0000; end
				default: begin toRam <= 16'b0000000000000000; trigger <= 0; start <= 0; data <= 8'b00000000; end	
				endcase
				end
		end
	end
endmodule