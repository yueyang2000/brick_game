module game_ball #(
	parameter radius = 4,
	parameter paddle_length = 60
	)(
	input wire clk,
	input wire rst,
	input wire [10:0] x_paddle,
	input wire [2:0] state,
	input wire [2:0] angle,
	input wire [19:0] period,
	input wire [2:0] level,
	output reg [1:0] brick [63:0],
	output reg [10:0] x,
	output reg [9:0] y,
	output reg dead,
	output reg win
);
reg [3:0] bx;
reg [3:0] by;
wire [3:0] bx_result;
wire [3:0] by_result;
integer dx, dy;
integer counter;
reg [10:0] next_x;
reg [9:0] next_y;
reg [10:0] find_x;
reg [10:0] find_y;
reg boundary; // 和边缘相撞，不需要检查与块碰撞
reg [6:0] target1;
reg [6:0] target2;
reg [6:0] target3;
reg [2:0] target_en;
wire [1:0] b1;
wire [1:0] b2;
wire [1:0] b3;
assign b1 = brick[target1[5:0]];
assign b2 = brick[target2[5:0]];
assign b3 = brick[target3[5:0]];
reg [7:0] brick_cnt;
brick_finder bf(
	.x(find_x),
	.y(find_y),
	.bx(bx_result),
	.by(by_result)
);

always @(posedge clk or negedge rst) begin
	if(!rst) begin
		counter <= 0;
		boundary <= 0;
		target_en <= 0;
	end
	else if(state == 1) begin //state1加载砖块
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
	else if(state == 2) begin //state2等待发射
		dead <= 0;
		win <= 0;
		x <= x_paddle; //球的发射位置随着板移动
		y <= 570 - radius - 1;
		counter <= 0;
		boundary <= 0;
		target_en <= 0;
		//根据角度选择速度方向
		case (angle)
			0: begin
				dx <= -2; dy <= -1;
			end
			1:begin
				dx <= -1;dy <= -1;
			end
			2:begin
				dx <= -1; dy <= -2;
			end
			3: begin
				dx <= 1; dy <= -2;
			end
			4: begin
				dx <= 1; dy <= -1;
			end
			5: begin
				dx <= 2; dy <= -1;
			end
			default: begin
				dx <= 1; dy <= -1;
			end
		endcase
	end
	else if(state == 3) begin //state3球开始运动
		if(counter == period - 1) begin
			counter <= 0;
			boundary <= 0;
			x <= next_x;
			y <= next_y;
		end
		else begin
			counter <= counter + 1;
			if(counter == period - 10) begin 
				//检查是否与边界相撞
				//注意如果某方向与边相撞，则另一个方向就不动了，这样比较省事
				if(x + dx <= radius + 1) begin
					dx <= -1*dx;
					next_x <= radius + 1;
					next_y <= y;
					boundary <= 1;
				end
				else if(x + dx + radius >= 800) begin
					dx <= -1*dx;
					next_x <= 800 - radius;
					next_y <= y;
					boundary <= 1;
				end
				if(y + dy <= radius + 1) begin
					dy <= -1*dy;
					next_y <= radius + 1;
					next_x <= x;
					boundary <= 1;
				end
				/*
				else if(y + dy + radius >= 600) begin
					dy <= -1*dy;
					next_y <= 600 - radius;
					next_x <= x;
					boundary <= 1;
				end
				*/
				else if(y + dy + radius >= 571) begin
					if(x>=x_paddle - paddle_length && x <= x_paddle + paddle_length) begin
						next_y <= 570-radius;
						dy <= -1*dy;
						next_x <= x;
						boundary <= 1;
					end
					else
						dead <= 1;
				end
			end
			else if(!boundary) begin //没有与边界碰撞，进入砖块检查
				if(counter == period - 9) begin
					find_x <= x; find_y <= y;
				end
				else if(counter == period - 8) begin
					bx <= bx_result; by <= by_result; 
				end
				else if(counter == period - 7) begin //检测下一步是否穿到别的砖块去了
					find_x <= x + dx; find_y <= y + dy;
				end
				else if(counter == period - 6) begin
					if(bx != bx_result) begin //x方向侧方穿入
						target1 <= (by<<3) + bx_result;
						if(by!=by_result) begin // 斜穿入对角方块，认为与三个方块接触
							target2 <= ((by_result)<<3) + bx;
							target3 <= ((by_result)<<3) + bx_result;
							target_en <= 3'b111;
						end
						else //穿入侧方
							target_en <= 3'b001;
					end
					else if(by!=by_result) begin//只在y方向穿入
						target2 <= (by_result<<3) + bx;
						target_en <= 3'b010;
					end
					else begin //没有碰撞
						target_en <= 0;
					end
				end
				else if(counter == period - 5) begin //检查碰撞情况，注意如果有碰撞则这回合就不动了，只变方向
					if(target_en == 3'b111) begin //斜撞，target3是斜方砖块
						//注意砖块范围0~63
						if(target1 < 64 && b1!=0) begin
							dx <= -1*dx;
							next_x <= x; next_y <= y;
							if(target2 < 64 && b2!=0) begin
								dy <= -1*dy;
								target_en[2] <= 0;//如果侧方两个砖块都有，那么斜方的砖块就不消去
							end
						end
						else if(target2<64 && b2!=0) begin
							dy <= -1*dy;
							next_x <= x; next_y <= y;
						end
						else if(target3<64 && b3!=0) begin//只有斜方砖块，侧方都没有
							dy <= -1*dy;
							dx <= -1*dx;
							next_x <= x; next_y <= y;
						end
						else begin
							next_x <= x + dx; 
							next_y <= y + dy;
						end
					end
					else if(target_en == 3'b001 && target1<64 && b1!=0) begin
						dx <= -1*dx;
						next_x <= x; next_y <= y;
					end
					else if(target_en == 3'b010 && target2<64 && b2!=0) begin
						dy <= -1*dy;
						next_x <= x; next_y <= y;
					end
					else begin
						next_x <= x + dx; 
						next_y <= y + dy;
					end
				end
				else if(counter == period - 4) begin
					//本拍中target_en充当是否碰撞三个target的标识
					//下一拍target_en充当是否-1的标识
					if(target1<64 && target_en[0] && b1!=0) begin
						brick[target1[5:0]] <= b1 - 1;
						target_en[0] <= 1;
					end
					else
						target_en[0] <= 0;
					if(target2<64 && target_en[1] && b2!=0) begin
						brick[target2[5:0]] <= b2 - 1;
						target_en[1] <= 1;
					end
					else
						target_en[1] <= 0;
					if(target3<64 && target_en[2] && b3!=0) begin
						brick[target3[5:0]] <= b3 - 1;
						target_en[2] <= 1;
					end
					else
						target_en[2] <= 0;
				end
				else if(counter == period - 3) begin //消减总块数
					if(target_en == 3'b111)
						brick_cnt <= brick_cnt - 3;
					else if(target_en == 3'b110 || target_en == 3'b101 || target_en == 3'b011)
						brick_cnt <= brick_cnt - 2;
					else if(target_en == 3'b100 || target_en == 3'b010 || target_en == 3'b001) 
						brick_cnt <= brick_cnt - 1;
				end
				else if(counter == period - 2) begin //检查获胜
					if(brick_cnt == 0)
						win <= 1;
				end
			end
		end
	end
end

endmodule

