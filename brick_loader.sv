module brick_loader(
	input wire clk,
	input wire rst,
	input wire [2:0] state,
	input wire [2:0] level,
	output reg [1:0] brick [63:0]
);
reg [7:0] brick_cnt;
always @(posedge clk or negedge rst) begin
	if(state == 1) begin //state1加载砖块
		case (level) 
			0: begin
			  brick_cnt <= 36;
           brick[0] <= 2; brick[1] <= 1; brick[2] <= 2; brick[3] <= 1;
           brick[4] <= 2; brick[5] <= 0; brick[6] <= 0; brick[7] <= 0;
           brick[8] <= 1; brick[9] <= 2; brick[10] <= 1; brick[11] <= 2;
           brick[12] <= 0; brick[13] <= 1; brick[14] <= 0; brick[15] <= 0;
           brick[16] <= 2; brick[17] <= 1; brick[18] <= 2; brick[19] <= 0;
           brick[20] <= 1; brick[21] <= 0; brick[22] <= 1; brick[23] <= 0;
           brick[24] <= 0; brick[25] <= 1; brick[26] <= 0; brick[27] <= 2;
           brick[28] <= 0; brick[29] <= 2; brick[30] <= 0; brick[31] <= 1;
           brick[32] <= 0; brick[33] <= 0; brick[34] <= 1; brick[35] <= 0;
           brick[36] <= 1; brick[37] <= 0; brick[38] <= 1; brick[39] <= 0;
           brick[40] <= 0; brick[41] <= 0; brick[42] <= 0; brick[43] <= 2;
           brick[44] <= 0; brick[45] <= 2; brick[46] <= 0; brick[47] <= 0;
           brick[48] <= 0; brick[49] <= 0; brick[50] <= 0; brick[51] <= 0;
           brick[52] <= 1; brick[53] <= 0; brick[54] <= 0; brick[55] <= 0;
           brick[56] <= 0; brick[57] <= 0; brick[58] <= 0; brick[59] <= 0;
           brick[60] <= 0; brick[61] <= 0; brick[62] <= 0; brick[63] <= 0;
			end
			1: begin
				brick_cnt <= 96;
            brick[0] <= 1; brick[1] <= 1; brick[2] <= 1; brick[3] <= 1;
            brick[4] <= 1; brick[5] <= 1; brick[6] <= 1; brick[7] <= 1;
            brick[8] <= 2; brick[9] <= 2; brick[10] <= 2; brick[11] <= 2;
            brick[12] <= 2; brick[13] <= 2; brick[14] <= 2; brick[15] <= 2;
            brick[16] <= 1; brick[17] <= 1; brick[18] <= 1; brick[19] <= 1;
            brick[20] <= 1; brick[21] <= 1; brick[22] <= 1; brick[23] <= 1;
            brick[24] <= 2; brick[25] <= 2; brick[26] <= 2; brick[27] <= 2;
            brick[28] <= 2; brick[29] <= 2; brick[30] <= 2; brick[31] <= 2;
            brick[32] <= 1; brick[33] <= 1; brick[34] <= 1; brick[35] <= 1;
            brick[36] <= 1; brick[37] <= 1; brick[38] <= 1; brick[39] <= 1;
            brick[40] <= 2; brick[41] <= 2; brick[42] <= 2; brick[43] <= 2;
            brick[44] <= 2; brick[45] <= 2; brick[46] <= 2; brick[47] <= 2;
            brick[48] <= 1; brick[49] <= 1; brick[50] <= 1; brick[51] <= 1;
            brick[52] <= 1; brick[53] <= 1; brick[54] <= 1; brick[55] <= 1;
            brick[56] <= 2; brick[57] <= 2; brick[58] <= 2; brick[59] <= 2;
            brick[60] <= 2; brick[61] <= 2; brick[62] <= 2; brick[63] <= 2;
			end
			default: begin
				brick_cnt <= 192;
				brick[0] <= 3; brick[1] <= 3; brick[2] <= 3; brick[3] <= 3;
            brick[4] <= 3; brick[5] <= 3; brick[6] <= 3; brick[7] <= 3;
            brick[8] <= 3; brick[9] <= 3; brick[10] <= 3; brick[11] <= 3;
            brick[12] <= 3; brick[13] <= 3; brick[14] <= 3; brick[15] <= 3;
            brick[16] <= 3; brick[17] <= 3; brick[18] <= 3; brick[19] <= 3;
            brick[20] <= 3; brick[21] <= 3; brick[22] <= 3; brick[23] <= 3;
            brick[24] <= 3; brick[25] <= 3; brick[26] <= 3; brick[27] <= 3;
            brick[28] <= 3; brick[29] <= 3; brick[30] <= 3; brick[31] <= 3;
            brick[32] <= 3; brick[33] <= 3; brick[34] <= 3; brick[35] <= 3;
            brick[36] <= 3; brick[37] <= 3; brick[38] <= 3; brick[39] <= 3;
            brick[40] <= 3; brick[41] <= 3; brick[42] <= 3; brick[43] <= 3;
            brick[44] <= 3; brick[45] <= 3; brick[46] <= 3; brick[47] <= 3;
            brick[48] <= 3; brick[49] <= 3; brick[50] <= 3; brick[51] <= 3;
            brick[52] <= 3; brick[53] <= 3; brick[54] <= 3; brick[55] <= 3;
            brick[56] <= 3; brick[57] <= 3; brick[58] <= 3; brick[59] <= 3;
            brick[60] <= 3; brick[61] <= 3; brick[62] <= 3; brick[63] <= 3;		
			end
		endcase
	end
end

endmodule

