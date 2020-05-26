module angle_controller(
	input wire clk,
	input wire rst,
	input wire [7:0] x,
	input wire [7:0] y,
	output reg [2:0] angle
);

//angles: (-2,-1),(-1,-1),(-1,-2),(1,-2)(1,-1)(1,-2)
always @(posedge clk or negedge rst) begin
	if(!rst) begin
		angle <= 4; // dx = 1, dy = -1
	end
	else if((!(y>32 && x>64 && x<192))&&(y<=128)) begin //x和y比较大的时候才选
		if(x==0)
			angle <= 0;
		else if(x<=64)
			angle <= 1;
		else if(x<128)
			angle <= 2;
		else if(x<= 192)
			angle <= 3;
		else if(x==255)
			angle <= 5;
		else
			angle <= 4;
//		if(x<=128) begin
//			if(((128-x)<<1)<=(y-128)) // 2*dx<=dy
//				angle <= 2;
//			else if((128-x)>=((y-128)<<1)) //dx>=2*dy
//				angle <= 0;
//			else
//				angle <= 1;
//		end
//		else begin
//			if(((x-128)<<1)<=(y-128)) //2*dx<=dy
//				angle <= 3;
//			else if((x-128)>=((y-128)<<1)) //dx>=2*dy
//				angle <= 5;
//			else
//				angle <= 4;
//		end
	end
end

endmodule

