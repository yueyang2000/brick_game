// state_manager.sv
//
// control stating

module state_manager(
	input wire clk,                 // clock
	input wire rst,                 // reset
	input wire circle,              // is circle clicked
	input wire square,              // is square clicked
	input wire dead,                // is dead
	input wire win,                 // is win
	input wire [2:0] angle,         // is angle
	output reg [2:0] state,         // game state
	output reg [2:0] life,          // game life
	output reg [19:0] period,       // game speed (counter)
	output reg [2:0] level          // game level
);
reg [19:0] base_period;
always @(posedge clk or negedge rst) begin
	if(!rst) begin
		state <= 0;
		level <= 0;
		life <= 0;
		base_period <= 120000;
	end
	else begin
		case (state)
			0: begin //game_ball加载局面level 
				state <= 1;
				life <= 5;
				base_period <= 120000;
			end
			1: begin
				state <= 2;
			end
			2: begin 
				//等待开始，用户选择位置和方向
				//按钮按下球启动，速度控制period给定
				if(angle == 1 || angle == 4)	
					period <= base_period;
				else
					period <= base_period + (base_period>>1); //注意这里球的整体速度是变快了的，否则难度会降低 150000
				if(circle) begin
					state <= 3;
				end
			end
			3: begin
				//球自由飞行，等待球死亡或砖块打完
				if(win) begin
					state <= 1;
					if(life < 5)
						life <= life + 1;
					if(level == 4) begin
						level <= 0;
						base_period <= base_period - (base_period >> 2); //速度变为4/3
					end
					else
						level <= level + 1;
				end
				else if(dead) begin
					if(life > 0) begin
						state <= 2;
						life <= life - 1;
					end
					else
						state <= 4;
				end
			end
			4: begin//game over
				if(square) begin
					state <= 0; // new game
					level <= 0;
				end
			end
		endcase
	end
end

endmodule
