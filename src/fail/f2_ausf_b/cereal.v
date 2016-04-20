module cereal (input wire sysclk,
               input wire [7:0] data,
               input wire start,
               output reg cereal,
               output reg status,
               output wire pulse);
  
  //wire pulse;
  
  // inst clockdiv
  clockdiv #(15,5207) clockdiv(.sysclk(sysclk),.pulse(pulse));
  
  // states
  parameter IDLE=4'b0000;
  parameter START=4'b0001;
  parameter BIT0=4'b0011;
  parameter BIT1=4'b0010;
  parameter BIT2=4'b0110;
  parameter BIT3=4'b0111;
  parameter BIT4=4'b0101;
  parameter BIT5=4'b0100;
  parameter BIT6=4'b1100;
  parameter BIT7=4'b1001;
  parameter DONE=4'b1011;
  
  reg [3:0] state = IDLE;
  
  reg start_latch = 1'b0;
  reg [7:0] data_latch = 8'b00000000;
  
  always @(posedge sysclk) begin
    if(status) data_latch <= data;
  end
  
  always @(posedge sysclk) begin
		if(start) start_latch <= 1'b1;
		else if (!status) start_latch <= 1'b0;
        else if (data_latch == 8'b00000000) start_latch <= 1'b0;
  end
  
  //next state
  always @(posedge pulse) begin
    case(state)
      IDLE: if (start_latch) state <= START;   // go to start
      START: state <= BIT0;   // send start bit
      BIT0: state <= BIT1;    // bits 0--7
      BIT1: state <= BIT2;
      BIT2: state <= BIT3;
      BIT3: state <= BIT4;
      BIT4: state <= BIT5;
      BIT5: state <= BIT6;
      BIT6: state <= BIT7;
      BIT7: state <= DONE;
      DONE: state <= IDLE;              // stop bit
      default: state <= IDLE;           // fallback
    endcase
  end
  
  //send data over cereal
  always @(*) begin
    case(state)
      IDLE: begin cereal = 1'b1; status = 1'b1; end                   // send high idle and status to ready
      START: begin cereal = 1'b0; status = 1'b0; end                  // send start bit and status to busy
      BIT0: begin cereal = data_latch[0]; status = 1'b0; end                                       // bits 0--7
      BIT1: begin cereal = data_latch[1]; status = 1'b0;end
      BIT2: begin cereal = data_latch[2]; status = 1'b0;end
      BIT3: begin cereal = data_latch[3]; status = 1'b0;end
      BIT4: begin cereal = data_latch[4]; status = 1'b0;end
      BIT5: begin cereal = data_latch[5]; status = 1'b0;end
      BIT6: begin cereal = data_latch[6]; status = 1'b0;end
      BIT7: begin cereal = data_latch[7]; status = 1'b0;end
      DONE: begin                                                     // stop bit and status to ready
        cereal = 1'b1;
        status = 1'b1;
        //start_latch = 1'b0;
      end                 
      default: begin cereal = 1'b1; status = 1'b1; end                       // fallback
    endcase
  end
endmodule
