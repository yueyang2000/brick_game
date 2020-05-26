module digital_7(
           output reg [6:0] display,
           input wire [3:0] number
       );

always @(number) begin
    case(number)
        4'b0000: display<= 7'b1111110;
        4'b0001: display<= 7'b1100000;
        4'b0010: display<= 7'b1011101;
        4'b0011: display<= 7'b1111001;
        4'b0100: display<= 7'b1100011;
        4'b0101: display<= 7'b0111011;
        4'b0110: display<= 7'b0111111;
        4'b0111: display<= 7'b1101000;
        4'b1000: display<= 7'b1111111;
        4'b1001: display<= 7'b1111011;
        4'b1010: display<= 7'b1101111;
        4'b1011: display<= 7'b0110111;
        4'b1100: display<= 7'b0011110;
        4'b1101: display<= 7'b1110101;
        4'b1110: display<= 7'b0011111;
        4'b1111: display<= 7'b0001111;
        default: display<= 7'b0000000;
    endcase
end
endmodule
