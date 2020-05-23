module render #(
	parameter paddle_length = 80,
	parameter radius = 4
	)(
	input wire clk,
	input wire rst,
	input wire [10:0] x_paddle_l,
	input wire [10:0] x_paddle_r,
	input wire [10:0] x_ball,
	input wire [9:0] y_ball,
	input wire [1:0] brick [63:0],
	input wire [10:0] x,
	input wire [9:0] y,
	input wire o_active,
	output reg [8:0] VGA
);

	 wire [3:0] bx;
	 wire [3:0] by;
	 wire [10:0] bx_start;
	 wire [9:0] by_start;
	 brick_finder bf(
		.x(x),
		.y(y),
		.bx(bx),
		.by(by),
		.x_start(bx_start),
		.y_start(by_start)
	 );
	 wire [5:0] brick_id;
	 assign brick_id = (by<<3) + bx;
	 wire [1:0] b;
	 assign b = brick[brick_id];
	 reg [8:0] ball_show;
	 reg [8:0] paddle_l_show;
	 reg [8:0] paddle_r_show;
	 reg [8:0] brick_show; 
	 always @(posedge clk) begin
			VGA <= ball_show|brick_show|paddle_r_show;
	 end
	 
	 always @(negedge clk) begin //在下降沿做计算
	 	if(!rst) begin
			ball_show <= 0;
			paddle_l_show <= 0;
			paddle_r_show <= 0;
			brick_show <= 0;
		end
		else if(o_active && x>0 && y>0) begin
			if(x>=x_paddle_r-paddle_length && x<= x_paddle_r+paddle_length && y>570 && y<=580)
				paddle_r_show <= 9'b111000000;
			else
				paddle_r_show <= 0;
			if(x>=x_paddle_l-paddle_length && x<= x_paddle_l+paddle_length && y>20 && y<=30)
				paddle_l_show <= 9'b000000111;
			else
				paddle_l_show <= 0;
			if(x>=x_ball-radius && x<= x_ball+radius && y>= y_ball-radius && y<=y_ball+radius) begin
				if(x== x_ball || y == y_ball)
					ball_show <= 9'b111111111;
				else if(x>=x_ball-2 && x<= x_ball+2 && y>=y_ball-3 && y<=y_ball+3)
					ball_show <= 9'b111111111;
				else if(y>=y_ball-2 && y<= y_ball+2 && x>=x_ball-3 && x<=x_ball+3)
					ball_show <= 9'b111111111;
				else
					ball_show <= 9'b000000000;
			end
			else
				ball_show <= 0;
			if(x>=bx_start+5 && x < bx_start + 95 && y<400 && y>=by_start+5 && y < by_start+45 && b!=0) begin
				case (b)
					1: brick_show <= 9'b111111111;
					2: brick_show <= 9'b111000000;
					3: brick_show <= 9'b000111111;
				endcase
			end
			else begin 
				brick_show <= 9'b000000000;
			end
		end
		else begin
			ball_show <= 0;
			paddle_l_show <= 0;
			paddle_r_show <= 0;
			brick_show <= 0;
		end
	end
endmodule
