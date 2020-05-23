
`default_nettype none

module brick_game(
    input wire CLK_100M,        // board clock: 100 MHz
    input wire M_nRESET,        // reset button
	 input wire ps2_di,
	 output wire ps2_do,
	 output wire ps2_sclk,
	 output wire ps2_scs,
    output wire VGA_HSYNC,      // horizontal sync output
    output wire VGA_VSYNC,      // vertical sync output
    output wire [2:0] VGA_R,    // 3-bit VGA red output
    output wire [2:0] VGA_G,    // 3-bit VGA green output
    output wire [2:0] VGA_B,     // 3-bit VGA blue output
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
	 
	 parameter radius = 4;
	 parameter paddle_length = 80;
	 wire circle;
	 wire [7:0] data_l;
	 wire [7:0] data_r;
	 wire [10:0] x_paddle_l;
	 wire [10:0] x_paddle_r;
	 wire [10:0] x_ball;
	 wire [9:0] y_ball;
	 wire [1:0] brick [63:0];
	 stick s(
		.CLK_40M(CLK_40M),
		.rst(M_nRESET),
		.di(ps2_di),
		.sdo(ps2_do),
		.sclk(ps2_sclk),
		.scs(ps2_scs),
		.data_r(data_r),
		.data_l(data_l),
		.circle(circle)
	 );
	 paddle #(.length(paddle_length))pr(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.control(data_r),
		.x_paddle(x_paddle_r)
	 );
	 paddle #(.length(paddle_length))pl(
		.clk(CLK_40M),
		.rst(M_nRESET),
		.control(data_l),
		.x_paddle(x_paddle_l)
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
		.start(circle),
		.x_paddle(x_paddle_r),
		.brick(brick),
		.x(x_ball),
		.y(y_ball)
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
		.VGA(VGA)
	 );
	digital_7 d1(display1,data_r[7:4]);
	digital_7 d2(display0,data_r[3:0]);
endmodule
