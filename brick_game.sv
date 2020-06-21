
`default_nettype none

module brick_game(
    input wire CLK_100M,        // board clock: 100 MHz
    input wire M_nRESET,        // reset button
	 input wire ps2_di,         // ps2 stick data input
	 output wire ps2_do,        // ps2 stick data output
	 output wire ps2_sclk,      // ps2 stick clock
	 output wire ps2_scs,       // ps2 stick control signal
    output wire VGA_HSYNC,      // horizontal sync output
    output wire VGA_VSYNC,      // vertical sync output
    output wire [2:0] VGA_R,    // 3-bit VGA red output
    output wire [2:0] VGA_G,    // 3-bit VGA green output
    output wire [2:0] VGA_B,     // 3-bit VGA blue output
	 output wire [6:0] display3,
	 output wire [6:0] display2,
	 output wire [6:0] display1,
	 output wire [6:0] display0
    );

	 wire CLK_40M;
	 pll p(
			.inclk0(CLK_100M),
			.c0(CLK_40M)
	 );
    // current pixel x position: 11-bit value: 0-2047
    // current pixel y position: 10-bit value: 0-1023
	 wire o_active;
	 wire [10:0] x_pixel;
	 wire [9:0] y_pixel;
	 wire [8:0] VGA;
	 assign {VGA_R, VGA_G, VGA_B} = VGA;
	 
	 
    vga800x600 display (
        .i_clk(CLK_40M),
        .i_rst(M_nRESET),
        .o_hs(VGA_HSYNC), 
        .o_vs(VGA_VSYNC),
		  .o_active(o_active),
        .o_x(x_pixel), 
        .o_y(y_pixel)
    );
	 wire [2:0] state;
	 wire [19:0] period;
	 wire [2:0] level;
	 wire dead, win;
	 state_manager sm(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.state(state),
		.angle(angle),
		.circle(circle),
		.square(square),
		.period(period),
		.level(level),
		.dead(dead),
		.win(win),
		.life(life)
	 );
	 
	 parameter radius = 4;
	 parameter paddle_length = 80;
	 wire circle, square;
	 //左摇杆选角度，右摇杆移动
	 wire [7:0] data_l_x, data_r_x, data_l_y;
	 wire [10:0] x_paddle_l, x_paddle_r;
	 wire [10:0] x_ball;
	 wire [9:0] y_ball;
	 wire [1:0] brick [63:0];
	 wire [2:0] angle;//共六种角度
	 wire [13:0] score;
	 wire [2:0] life;
	 wire [3:0] n3, n2, n1, n0;
	 
	 ps2_stick s(
		.CLK_40M(CLK_40M),
		.rst(M_nRESET),
		.di(ps2_di),
		.sdo(ps2_do),
		.sclk(ps2_sclk),
		.scs(ps2_scs),
		.data_r_x(data_r_x),
		.data_l_y(data_l_y),
		.data_l_x(data_l_x),
		.circle(circle),
		.square(square)
	 );
	 paddle #(.length(paddle_length))pr(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.control(data_r_x),
		.x_paddle(x_paddle_r)
	 );
	 paddle #(.length(paddle_length))pl(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.control(data_l_x),
		.x_paddle(x_paddle_l)
	 );
	 angle_controller ac(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.x(data_l_x),
		.y(data_l_y),
		.angle(angle)
	 );
	 /*
	 pingpong #(.radius(radius)) b(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.x_paddle_l(x_paddle_l),
		.x_paddle_r(x_paddle_r),
		.x(x_ball),
		.y(y_ball)
	 );
	 */
	 game_ball #(.radius(radius),.paddle_length(paddle_length)) gb(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.x_paddle(x_paddle_r),
		.brick(brick),
		.x(x_ball),
		.y(y_ball),
		.period(period),
		.state(state),
		.angle(angle),
		.level(level),
		.dead(dead),
		.win(win),
		.score(score)
	 );
	 score_to_digit (
		.clk(CLK_40M),
		.rst(M_nRESET),
		.score(score),
		.n3(n3),
		.n2(n2),
		.n1(n1),
		.n0(n0)
	 );
	 render #(.paddle_length(paddle_length),.radius(radius))r(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.x_paddle_l(x_paddle_l),
		.x_paddle_r(x_paddle_r),
		.x_ball(x_ball),
		.y_ball(y_ball),
		.brick(brick),
		.x(x_pixel),
		.y(y_pixel),
		.o_active(o_active),
		.angle(angle),
		.state(state),
		.life(life),
		.VGA(VGA)
	 );
	digital_7 d3(display3, n3);
	digital_7 d2(display2, n2);
	digital_7 d1(display1, n1);
	digital_7 d0(display0, n0);
endmodule
