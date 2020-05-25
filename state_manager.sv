module state_manager(
	input wire clk,
	input wire rst,
	input wire circle,
	input wire dead,
	input wire win,
	output reg [2:0] state,
	output reg [19:0] period,
	output reg [2:0] level
);

always @(posedge clk or negedge rst) begin
	if(!rst) begin
		state <= 0;
		level <= 0;
	end
	else begin
		case (state)
			0: begin //game_ball加载局面level 
				state <= 1;
			end
			1: begin
				state <= 2;
			end
			2: begin 
				//等待开始，用户选择位置和方向
				//按钮按下球启动，速度控制period给定
				period <= 100000;
				if(circle) begin
					state <= 3;
				end
			end
			3: begin
				//球自由飞行，等待球死亡或砖块打完
				if(win) begin
					state <= 1;
					level <= level + 1;
				end
				else if(dead) begin
					state <= 2;
				end
			end
		endcase
	end
end

endmodule
