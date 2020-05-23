module game_ball #(
	parameter radius = 4,
	parameter paddle_length = 60
	)(
	input wire clk,
	input wire rst,
	input wire start,
	input wire [10:0] x_paddle,
	output reg [1:0] brick [63:0],
	output reg [10:0] x,
	output reg [9:0] y
);
parameter period = 100000;
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
brick_finder bf(
	.x(find_x),
	.y(find_y),
	.bx(bx_result),
	.by(by_result)
);

reg state;
always @(posedge clk or negedge rst) begin
	if(!rst) begin
		dx <= 1;
		dy <= -1;
		x <= 400;
		y <= 560;
		counter <= 0;
		boundary <= 0;
		target_en <= 0;
		state <= 0;
		brick[0] <= 2'b11;brick[1] <= 2'b11;brick[2] <= 2'b11;brick[3] <= 2'b11;brick[4] <= 2'b11;
		brick[5] <= 2'b11;brick[6] <= 2'b11;brick[7] <= 2'b11;brick[8] <= 2'b11;brick[9] <= 2'b11;
		brick[10] <= 2'b11;brick[11] <= 2'b11;brick[12] <= 2'b11;brick[13] <= 2'b11;brick[14] <= 2'b11;
		brick[15] <= 2'b11;brick[16] <= 2'b11;brick[17] <= 2'b11;brick[18] <= 2'b11;brick[19] <= 2'b11;
		brick[20] <= 2'b11;brick[21] <= 2'b11;brick[22] <= 2'b11;brick[23] <= 2'b11;brick[24] <= 2'b11;
		brick[25] <= 2'b11;brick[26] <= 2'b11;brick[27] <= 2'b11;brick[28] <= 2'b11;brick[29] <= 2'b11;
		brick[30] <= 2'b11;brick[31] <= 2'b11;brick[32] <= 2'b11;brick[33] <= 2'b11;brick[34] <= 2'b11;
		brick[35] <= 2'b11;brick[36] <= 2'b11;brick[37] <= 2'b11;brick[38] <= 2'b11;brick[39] <= 2'b11;
		brick[40] <= 2'b11;brick[41] <= 2'b11;brick[42] <= 2'b11;brick[43] <= 2'b11;brick[44] <= 2'b11;
		brick[45] <= 2'b11;brick[46] <= 2'b11;brick[47] <= 2'b11;brick[48] <= 2'b11;brick[49] <= 2'b11;
		brick[50] <= 2'b11;brick[51] <= 2'b11;brick[52] <= 2'b11;brick[53] <= 2'b11;brick[54] <= 2'b11;
		brick[55] <= 2'b11;brick[56] <= 2'b11;brick[57] <= 2'b11;brick[58] <= 2'b11;brick[59] <= 2'b11;
		brick[60] <= 2'b11;brick[61] <= 2'b11;brick[62] <= 2'b11;brick[63] <= 2'b11;
	end
	else if(state == 0) begin
		dx <= 1;
		dy <= -1;
		x <= x_paddle; //球的发射位置随着板移动
		y <= 500;
		counter <= 0;
		boundary <= 0;
		next_x <= 400;
		next_y <= 500;
		target_en <= 0;
		if(start)
			state <= 1;
	end
	else begin
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
					else begin
						state <= 0;
					end
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
					if(target1<64 && target_en[0] && b1!=0)
						brick[target1[5:0]] <= b1 - 1;
					if(target2<64 && target_en[1] && b2!=0)
						brick[target2[5:0]] <= b2 - 1;
					if(target3<64 && target_en[2] && b3!=0)
						brick[target3[5:0]] <= b3 - 1;
				end
			end
		end
	end
end

endmodule

