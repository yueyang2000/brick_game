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
	else if(!(y>64 && y<192 && x>64 && x<192)) begin //x和y比较大的时候才选
		if(x<128) begin
			angle <= 1;
		end
		else begin
			angle <= 4;
		end
	end
end

endmodule

