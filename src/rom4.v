module rom4 (input wire [3:0] addr, output reg [7:0] data);
    always @(in) begin
        case(in)
            4'b0000: data = 8'b01000110; // F
            4'b0001: data = 8'b01010000; // P
            4'b0010: data = 8'b01000111; // G
            4'b0011: data = 8'b01000001; // A
            default: data = 8'b00000000;
        endcase
    end
endmodule
