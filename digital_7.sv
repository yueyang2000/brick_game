module digital_7(
	output reg [6:0] display,
	input wire [3:0] number
);

always @(number) begin
	case(number)
		4'b0000: begin
			display<= 7'b1111110;
			end
		4'b0001: begin
			display<= 7'b1100000;
			end
		4'b0010: begin
			display<= 7'b1011101;
			end
		4'b0011: begin
			display<= 7'b1111001;
			end
		4'b0100: begin
			display<= 7'b1100011;
			end
		4'b0101: begin
			display<= 7'b0111011;
			end
		4'b0110: begin
			display<= 7'b0111111;
			end
		4'b0111: begin
			display<= 7'b1101000;
			end
		4'b1000: begin
			display<= 7'b1111111;
			end
		4'b1001: begin
			display<= 7'b1111011;
		end
		default: begin
			display<= 7'b0000000;
		end
	endcase
end
endmodule