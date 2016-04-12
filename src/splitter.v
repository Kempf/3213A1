module splitter (
	input wire clk,
	input wire sw1,
	input wire sw2,
	input wire sw3,
	input wire sw4,
	input wire holder,
	input wire sw1_latch,
	input wire sw2_latch,
	input wire sw3_latch,
	input wire sw4_latch,	
	input wire [7:0] rom1,
	input wire [7:0] rom2,
	input wire [7:0] rom3,
	input wire [7:0] rom4,
	output reg [7:0] currentData,
	output reg [7:0] count);

	// Is this correct syntax?
	reg [1:0] signum = 2'b00;
	reg [3:0] count11;
	
    // next state
    always @(posedge clk) begin
		if (holder == 1)
			begin
				if ((signum == 0) && (count == 131))
					begin 
						count <= 8'b00000000;
						signum <= 1;
					end
				else if ((signum == 1) && (count == 120))
					begin 
						signum <= 2;
						count <= 0;
					end
				else if ((signum == 2) && (count == 87))
					begin 
						signum <= 3;
						count <= 0;
					end
				else if ((signum == 3) && (count == 54))
					begin 
						signum <= 0;
						count <= 0;
					end
				else 	count <= count + 1;
				
				if (count11 == 10) count11<=4'b0000;
				else count11 <= count11 + 1;
				
				if ((sw1 == 1) && (signum == 0))
					begin 
						currentData <= rom1;
					end
				else if ((sw2== 1) && (signum == 1))
					begin 
						currentData <= rom2;
					end 
				else if ((sw3 == 1) && (signum == 2))
					begin 
						currentData <= rom3;
					end
				else if ((sw4 == 1) && (signum == 3))
					begin 
						currentData <= rom4;
					end
				else currentData <= 8'b00000000;
			end
		else 
			begin
				count <= 0;
				count11 <= 0;
				currentData <= 8'b00000000;
				if (sw1 == 1) signum <= 0;
				else if (sw2 == 1) signum <= 1;
				else if (sw3 == 1) signum <= 2;
				else if (sw4 == 1) signum <= 3;
				else signum <= 0;
			end
		end
		if (auto_latch == 1)
			begin
				if ((signum == 0) && (count == 131))
					begin 
						count <= 0;
						if (sw2_latch==1) <= signum = 1;
						else if (sw3_latch == 1) <= 2;
						else if (sw4_latch == 1) <= 3;
						else signum = 0;
					end
				else if ((signum == 1) && (count == 120))
					begin 
						count <= 0;
						if (sw3_latch==1) <= signum = 2;
						else if (sw4_latch == 1) <= 3;
						else if (sw1_latch == 1) <= 0;
						else signum = 1;
					end
				else if ((signum == 2) && (count == 87))
					begin 
						count <= 0;
						if (sw4_latch==1) <= signum = 3;
						else if (sw1_latch == 1) <= 0;
						else if (sw2_latch == 1) <= 1;
						else signum = 2;
					end
				else if ((signum == 3) && (count == 54))
					begin 
						count <= 0;
						if (sw1_latch==1) <= signum = 0;
						else if (sw2_latch == 1) <= 1;
						else if (sw3_latch == 1) <= 2;
						else signum = 3;
					end
				else 	count <= count + 1;
				
				if (count11 == 10) count11<=4'b0000;
				else count11 <= count11 + 1;
				
				if ((sw1 == 1) && (signum == 0))
					begin 
						currentData <= rom1;
					end
				else if ((sw2== 1) && (signum == 1))
					begin 
						currentData <= rom2;
					end 
				else if ((sw3 == 1) && (signum == 2))
					begin 
						currentData <= rom3;
					end
				else if ((sw4 == 1) && (signum == 3))
					begin 
						currentData <= rom4;
					end
				else currentData <= 8'b00000000;
			end
		else 
			begin
				count <= 0;
				count11 <= 0;
				currentData <= 8'b00000000;
				if (sw1 == 1) signum <= 0;
				else if (sw2 == 1) signum <= 1;
				else if (sw3 == 1) signum <= 2;
				else if (sw4 == 1) signum <= 3;
				else signum <= 0;
			end
		end
		end
endmodule
