module debouncer (input wire btn, input wire sysclk, output wire btn_deb);

wire pulse;

// create clockdiv
clockdiv #(16) cd(.sysclk(sysclk),.pulse(pulse));

// flip-flops
reg [2:0] ff = 2'b00;  
reg ff_out = 0;

always @(posedge sysclk) begin	
  	ff_out<=ff[0]&ff[1]&ff[2]; 
	if(pulse) begin
	     ff[0]<=btn;
	     ff[1]<=ff[0];
	     ff[2]<=ff[1];
	end
end


//output logic
assign	btn_deb=(ff[0]&ff[1]&ff[2])&(~ff_out);

endmodule
