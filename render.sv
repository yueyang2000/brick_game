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
           input wire [2:0] state,
           input wire [2:0] angle,
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
reg [8:0] ball_show;
reg [8:0] ghost_show;
//ghost是为了瞄准而显示的小球影子
reg [10:0] x_ghost;
reg [9:0] y_ghost;

reg [8:0] paddle_l_show;
reg [8:0] paddle_r_show;
reg [8:0] brick_show;

always @(posedge clk) begin //在下降沿做计算
    if(!rst) begin
        ball_show <= 0;
        ghost_show <= 0;
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

        case (angle)
            0: begin
                x_ghost <= x_ball - 51;
                y_ghost <= y_ball - 25;
            end
            1: begin
                x_ghost <= x_ball - 40;
                y_ghost <= y_ball - 40;
            end
            2: begin
                x_ghost <= x_ball - 25;
                y_ghost <= y_ball - 51;
            end
            3: begin
                x_ghost <= x_ball + 25;
                y_ghost <= y_ball - 51;
            end
            4: begin
                x_ghost <= x_ball + 40;
                y_ghost <= y_ball - 40;
            end
            5: begin
                x_ghost <= x_ball + 51;
                y_ghost <= y_ball - 25;
            end
            default: begin
                x_ghost <= x_ball + 40;
                y_ghost <= y_ball - 40;
            end
        endcase

        if(x>=x_ghost-radius && x<= x_ghost+radius && y>= y_ghost-radius && y<=y_ghost+radius) begin
            if(x== x_ghost || y == y_ghost)
                ghost_show <= 9'b010010010;
            else if(x>=x_ghost-2 && x<= x_ghost+2 && y>=y_ghost-3 && y<=y_ghost+3)
                ghost_show <= 9'b010010010;
            else if(y>=y_ghost-2 && y<= y_ghost+2 && x>=x_ghost-3 && x<=x_ghost+3)
                ghost_show <= 9'b010010010;
            else
                ghost_show <= 9'b000000000;
        end
        else
            ghost_show <= 0;
        if(x>=bx_start+5 && x < bx_start + 95 && y<400 && y>=by_start+5 && y < by_start+45 && brick[(by<<3) + bx]!=0) begin
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
    if(state == 2) begin
        VGA <= ball_show|brick_show|paddle_r_show|ghost_show;
    end
    else if(state > 2) begin
        VGA <= ball_show|brick_show|paddle_r_show;
    end
end
endmodule
