module stick(
	input wire CLK_40M,
	input wire rst,
	input wire di,
	output reg sdo,
	output reg sclk,
	output reg scs,
	output wire [7:0] data_l_x,
	output wire [7:0] data_r_x,
	output wire [7:0] data_l_y,
	output wire [6:0] display1,
	output wire [6:0] display0,
	output wire circle,
	output wire square
);

reg clk_6us = 0;
reg clk_1020us = 0;
integer cnt_6us = 0;
integer cnt_1020us = 0;
always @(posedge CLK_40M or negedge rst) begin
	if(!rst) begin
		cnt_6us <= 0;
		clk_6us <= 0;
		cnt_1020us <= 0;
		clk_1020us <= 0;
	end
	else begin
		if(cnt_6us == 119) begin
			cnt_6us <= 0;
			clk_6us <= ~clk_6us;
		end
		else
			cnt_6us <= cnt_6us + 1;
		if(cnt_1020us == 20399) begin
			cnt_1020us <=0;
			clk_1020us <= ~clk_1020us;
		end
		else
			cnt_1020us <= cnt_1020us + 1;
	end
end

integer cnt_trig = 0;
reg trig = 1;
always @(posedge clk_1020us) begin
	cnt_trig <= cnt_trig + 1;
	if(cnt_trig == 1)
		trig <= 0;
	else if (cnt_trig == 2)
		trig <= 1;
	else if(cnt_trig == 20)
		cnt_trig <= 0;
end 

reg [7:0] din1;
reg [7:0] din2;
reg [7:0] din3;
reg [7:0] din4;
reg [7:0] din5;
reg [7:0] din6;
assign data_r_x = din3;
assign data_l_x = din5;
assign data_l_y = din6;
assign circle = ~din2[5];
assign square = ~din2[7];
integer counter = 0;

always @(posedge clk_6us) begin
	if(trig == 0) begin
		scs <= 0;
		counter <= counter + 1;
		//同步时钟信号
		if ((0<counter)&(counter<17))
			sclk <= ~sclk;
		else if ((19<counter)&(counter<36))
			sclk <= ~sclk;
		else if ((38<counter)&(counter<55))
			sclk <= ~sclk;
		else if ((57<counter)&(counter<74))
			sclk <= ~sclk;
		else if ((76<counter)&(counter<93))
			sclk <= ~sclk;
		else if ((95<counter)&(counter<112))
			sclk <= ~sclk;
		else if ((114<counter)&(counter<131))
			sclk <= ~sclk;
		else if ((133<counter)&(counter<150))
			sclk <= ~sclk;
		else if ((152<counter)&(counter<169))
			sclk <= ~sclk;
		
		//主机发送0x01和0x42
		if(counter < 2)
			sdo <= 1;
		else if((20<counter)&(counter<23))
			sdo <= 1;
		else if((30<counter)&(counter<33))
			sdo <= 1;
		else
			sdo <= 0;
			
		//接受消息
		//byte4: 58~72
		//byte5: 77~91
		//byte6: 96~110
		//byte7: 115~129
		//byte8: 134~148
		//byte9: 153~167 
		if(counter == 58)
			din1[0] <= di;
		else if(counter == 60)
			din1[1] <= di;
		else if(counter == 62) 
			din1[2] <= di;
		else if(counter == 64) 
			din1[3] <= di;
		else if(counter == 66) 
			din1[4] <= di;
		else if(counter == 68) 
			din1[5] <= di;
		else if(counter == 70) 
			din1[6] <= di;
		else if(counter == 72)
			din1[7] <= di;
		else if(counter == 77)
			din2[0] <= di;
		else if(counter == 79)
			din2[1] <= di;
		else if(counter == 81) 
			din2[2] <= di;
		else if(counter == 83) 
			din2[3] <= di;
		else if(counter == 85) 
			din2[4] <= di;
		else if(counter == 87) 
			din2[5] <= di;
		else if(counter == 89) 
			din2[6] <= di;
		else if(counter == 91)
			din2[7] <= di;
		else if(counter == 96)
			din3[0] <= di;
		else if(counter == 98)
			din3[1] <= di;
		else if(counter == 100) 
			din3[2] <= di;
		else if(counter == 102) 
			din3[3] <= di;
		else if(counter == 104) 
			din3[4] <= di;
		else if(counter == 106) 
			din3[5] <= di;
		else if(counter == 108) 
			din3[6] <= di;
		else if(counter == 110)
			din3[7] <= di;
		else if(counter == 115)
			din4[0] <= di;
		else if(counter == 117)
			din4[1] <= di;
		else if(counter == 119) 
			din4[2] <= di;
		else if(counter == 121) 
			din4[3] <= di;
		else if(counter == 123) 
			din4[4] <= di;
		else if(counter == 125) 
			din4[5] <= di;
		else if(counter == 127) 
			din4[6] <= di;
		else if(counter == 129)
			din4[7] <= di;
		else if(counter == 134)
			din5[0] <= di;
		else if(counter == 136)
			din5[1] <= di;
		else if(counter == 138) 
			din5[2] <= di;
		else if(counter == 140) 
			din5[3] <= di;
		else if(counter == 142) 
			din5[4] <= di;
		else if(counter == 144) 
			din5[5] <= di;
		else if(counter == 146) 
			din5[6] <= di;
		else if(counter == 148)
			din5[7] <= di;
		else if(counter == 153)
			din6[0] <= di;
		else if(counter == 155)
			din6[1] <= di;
		else if(counter == 157) 
			din6[2] <= di;
		else if(counter == 159) 
			din6[3] <= di;
		else if(counter == 161) 
			din6[4] <= di;
		else if(counter == 163) 
			din6[5] <= di;
		else if(counter == 165) 
			din6[6] <= di;
		else if(counter == 167)
			din6[7] <= di;
	end
	else if(trig == 1) begin
		scs <= 1;
		sclk <= 1;
		counter <= 0;
	end
end

endmodule
