module tweetboard (input wire sysclk, input wire reset, input wire serialIn, input wire btn_write, output wire out_fin);

	wire btn_deb;						// debounced inputs
	wire reset_deb;
	wire pulse;			            // hearbeats for sampling and outputting
	wire writePulse;
	
	reg btn_latch = 1'b0;         // write button latch
	reg [7:0] addr;               // ROM address

	reg [3:0] counter;		    	// recieved bit counter
	wire [15:0] ramIn;		    	// RAM output (don't ask me why it's called "in")
	reg [15:0] toRam;		   		// input into ram	
	reg trigger;		    			// RAM write trigger
	reg reset_latch = 1'b0;			// reset mode
	wire out;                   	// intermidiate output for the mux
	reg delay;							// delay for the start signal
	reg bs;								// backspace flag
	reg [12:0] count_5207;			// sync timer
	reg underLimit;					// 160 char flag
    reg [7:0] data;                 // variables for cereal
    reg start, store_latch;
    
	// please stop looking, it may break the code
	    
	// inst debouncer
	debouncer w_debouncer(.sysclk(sysclk),.btn(btn_write), .btn_deb(btn_deb));
	debouncer r_debouncer(.sysclk(sysclk),.btn(reset), .btn_deb(reset_deb));
	// inst cereal
	cereal cereal(.sysclk(sysclk),.data(data),.start(start),.cereal(out),.pulse(pulse));
	// 10 serial bit pulse
	clockdiv #(17,52070) writeDiv(.sysclk(sysclk),.pulse(writePulse));
	// instantiate ram
	ram ram(.sysclk(sysclk), .write(trigger), .addr(addr), .data_in(toRam), .data_out(ramIn));
	// MUX for serial writing
	l_mux l_mux(.writeOut(out), .serialIn(serialIn), .select(store_latch), .underLimit(underLimit), .out(out_fin));
	
	// send
	always @(posedge sysclk) begin  
		// reset all the RAM
		if (reset_latch) begin
				addr <= addr + 1;
				trigger <= 1;
				toRam <= 16'b0000000000000000;
			if (addr == 255) begin
				reset_latch <= 0;
				addr <= 0;
			end
		end
		// reset regs
		if (reset_deb) begin
			count_5207 <= 13'b0000000000000;
			reset_latch <= 1;
			addr <= 0;
			btn_latch <= 0;
			toRam <= 16'b0000000000000000;
			counter <= 4'b0000;
			store_latch <= 0;
			start <= 0;
			data <= 8'b00000000;
			bs <= 0;
			delay <= 0;
			underLimit <= 1;
		end else		
		begin
			if (addr < 160) underLimit <= 1;
			else underLimit <= 0;
			// end serial frame if 10 bits are recieved
			// start recieving serial
			if ((serialIn == 0) && (store_latch == 0)) begin 
				store_latch <= 1'b1;
				toRam[15] <= 1; // identifies that data is stored at this address
				counter <= 1;
			end
			// if a value is stored in this RAM position, print. Else, finished.
			if (ramIn[15] == 1) 
			begin
				if (btn_latch && writePulse) begin
					data <= ramIn[7:0];
					start <= 1'b1; // start transmission
					delay <= 1'b1;
				end else if (btn_latch && delay) begin
					delay <= 1'b0;
					addr <= addr + 8'b00000001; // next letter
				end
			end else 
			begin
				if (btn_latch && writePulse) begin
					btn_latch <= 0;
					start <= 1'b0;
				end
			end
			// enter output mode
			if (btn_deb && ~store_latch) begin
				btn_latch <= 1;
				addr <= 4'b0000;
			end
			// store recieved bits
			if (store_latch) begin
				// increment recieved bit counter
				if (count_5207 == 5207) begin counter <= counter + 1; count_5207 <= 13'b0000000000000; end  //1010001010111 == 2507
				else begin count_5207 <= count_5207 + 1;
				case (counter) 
						  4'b0000: begin toRam <= 16'b0000000000000000; trigger <= 0; data <= 8'b00000000; end
						  4'b0010: begin if (count_5207 == 2600) begin toRam[0] <= serialIn; toRam[15] <= 1; end end // sample in (almost) the middle of the bit
						  4'b0011: begin if (count_5207 == 2600) begin toRam[1] <= serialIn; end end
						  4'b0100: begin if (count_5207 == 2600) begin toRam[2] <= serialIn; end end
						  4'b0101: begin if (count_5207 == 2600) begin toRam[3] <= serialIn; end end
						  4'b0110: begin if (count_5207 == 2600) begin toRam[4] <= serialIn; end end
						  4'b0111: begin if (count_5207 == 2600) begin toRam[5] <= serialIn; end end
						  4'b1000: begin if (count_5207 == 2600) begin toRam[6] <= serialIn; end end
						  // deal with backspace
						  4'b1001: begin 
								if((toRam == 16'b1000000000001000) && (bs == 0) && (addr != 0)) begin toRam <= 16'b0000000000000000; addr <= addr - 1; bs <= 1; end
								else if ((toRam == 16'b1000000000001000) && (addr == 0)) begin toRam <= 16'b0000000000000000; data <= 8'b00000000; counter <= 4'b0000; store_latch <= 0; trigger <= 0; bs <= 0; end
						  end
						  4'b1010: begin 
								if(addr <160) begin trigger <= 1; end
						  end
						  4'b1011: begin if(toRam != 16'b1000000000001000) begin addr <= addr + 1; end data <= 8'b00000000; counter <= 4'b0000; store_latch <= 0; trigger <= 0; bs <= 0; end
						  default: begin toRam <= 16'b0000000000000000; trigger <= 0; data <= 8'b00000000; bs <= 0; end	
					endcase
				end
			end
		end
	end
endmodule
