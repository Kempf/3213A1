`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:41:19 04/07/2016
// Design Name:   splitter
// Module Name:   D:/Uni/2016/Semester 1/3213/Assignment 1/ise/funct2/tb_splitter.v
// Project Name:  funct2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: splitter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_splitter;

	// Inputs
	reg sysclk;
	reg sw1;
	reg sw2;
	reg sw3;
	reg sw4;
	reg holder;
	reg [7:0] rom1;
	reg [7:0] rom2;
	reg [7:0] rom3;
	reg [7:0] rom4;

	// Outputs
	wire out;
	wire [3:0] count8;
	wire [7:0] count;

	// Instantiate the Unit Under Test (UUT)
	splitter uut (
		.sysclk(sysclk), 
		.sw1(sw1), 
		.sw2(sw2), 
		.sw3(sw3), 
		.sw4(sw4), 
		.holder(holder), 
		.rom1(rom1), 
		.rom2(rom2), 
		.rom3(rom3), 
		.rom4(rom4), 
		.out(out), 
		.count8(count8), 
		.count(count)
	);
initial begin
        sysclk=1'b0;
        forever #1 sysclk = ~sysclk;
    end

	initial begin
        $dumpfile("control.vcd");
        $dumpvars;
		  rom1 = 8'b01010101;
		  rom2 = 8'b10101010;
		  rom3 = 8'b00111100;
		  rom4 = 8'b11000011;
        sw1 = 1'b0;
        sw2 = 1'b0;
        sw3 = 1'b0;
        sw4 = 1'b0;
        holder = 1'b0;
        #1000 sw1 = 1'b1;
        #5000 sw1 = 1'b0;
        #6000 holder = 1'b1;
        #407000 holder = 1'b0;
        #410000 sw1 = 1'b1;
        #415000 holder = 1'b1;
        #820000 holder = 1'b0;
        #825000 sw1 = 1'b1;
        #830000 sw1 = 1'b1;
        #830000 sw2 = 1'b1;
        #830000 sw3 = 1'b1;
        #832000 holder = 1'b1;
        #1235000 holder = 1'b0;
        #1240000 sw4 = 1'b1;
        #1245000 holder = 1'b1;
        #1850000 sw1 = 1'b0;
        #1850000 sw2 = 1'b0;
        #1850000 sw3 = 1'b0;
        #1850000 sw4 = 1'b0;
        #1870000 holder = 1'b0;
        #2000000; $finish;
        
		// Add stimulus here

	end
      
endmodule

