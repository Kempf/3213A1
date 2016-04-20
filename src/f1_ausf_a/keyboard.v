module keyboard (input wire sysclk, input wire sw1, input wire sw2, input wire sw3, input wire sw4, input wire btn, output wire out, output wire pulse);

    wire btn_deb;
    reg start; //hold time of 5702 clock cycles
    wire status; //cereal status
    wire [3:0] in;
    reg [7:0] data;
    
    // inst debouncer
    debouncer debouncer(.sysclk(sysclk),.btn(btn),.btn_deb(btn_deb));
    // inst cereal
    cereal cereal(.sysclk(sysclk),.data(data),.start(start),.cereal(out),.status(status),.pulse(pulse));
    
    // assemble input
    assign in[0] = sw1;
    assign in[1] = sw2;
    assign in[2] = sw3;
    assign in[3] = sw4;
    
    // set data to send
    always @(in) begin
        case(in)
        4'b0000: data = 8'b00110000; // send 0
        4'b0001: data = 8'b00110001; // send 1
        4'b0010: data = 8'b00110010; // send 2
        4'b0011: data = 8'b00110011; // send 3
        4'b0100: data = 8'b00110100; // send 4
        4'b0101: data = 8'b00110101; // send 5
        4'b0110: data = 8'b00110110; // send 6
        4'b0111: data = 8'b00110111; // send 7
        4'b1000: data = 8'b00111000; // send 8
        4'b1001: data = 8'b00111001; // send 9
        4'b1111: data = 8'b01010101; // send U
        default: data = 8'b00000000; // send NOTHING!
        endcase
    end
    
    // send
    always @(posedge sysclk) begin
        if(btn_deb && (data != 8'b00000000)) begin     // start transmission
            start <= 1'b1;
        end
        else start <= 1'b0;                            // release start
    end
    
endmodule
