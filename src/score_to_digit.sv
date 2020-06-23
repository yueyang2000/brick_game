// score_to_digit.sv
//
// split score into four digits

module score_to_digit(
	input wire clk,             // clock
	input wire rst,             // reset
	input wire [13:0] score,    // score
	output reg [3:0] n3,        // score digit 3
	output reg [3:0] n2,        // score digit 2
	output reg [3:0] n1,        // score digit 1
	output reg [3:0] n0         // score digit 0
);

reg [13:0] prev_score;
always @(posedge clk) begin
	if(!rst) begin
		n3 <= 0; n2 <= 0; n1 <= 0; n0 <= 0;
		prev_score <= 0;
	end
	else begin
		if(prev_score != score) begin
			if(score > prev_score) begin
				prev_score <= prev_score + 1;
				if(n0 == 9) begin
					n0 <= 0;
					if(n1 == 9) begin
						n1 <= 0;
						if(n2 == 9) begin
							n2 <= 0;
							if(n3 == 9)
								n3 <= 0;
							else
								n3 <= n3 + 1;
						end
						else
							n2 <= n2 + 1;
					end
					else
						n1 <= n1 + 1;
				end
				else
					n0 <= n0 + 1;
			end
			else begin
				prev_score <= 0;
				n0 <= 0; n1 <= 0; n2 <= 0; n3 <= 0;
			end
		end
	end
end

endmodule
