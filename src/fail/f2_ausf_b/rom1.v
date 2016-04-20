module rom1 (input wire [3:0] addr, output reg [7:0] data);
    always @(addr) begin
        case(addr)
            4'b0000: data = 8'b01000101; // E
            4'b0001: data = 8'b01001110; // N
            4'b0010: data = 8'b01000111; // G
            4'b0011: data = 8'b01001001; // I
            4'b0100: data = 8'b01001110; // N
            4'b0101: data = 8'b01000101; // E
            4'b0110: data = 8'b01000101; // E
            4'b0111: data = 8'b01010010; // R
            4'b1000: data = 8'b01001001; // I
            4'b1001: data = 8'b01001110; // N
            4'b1010: data = 8'b01000111; // G
			4'b1011: data = 8'b00100000;
            default: data = 8'b00000000;
        endcase
    end
endmodule
