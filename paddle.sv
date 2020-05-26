module paddle #(
           parameter length = 60
       )(
           input wire clk,
           input wire rst,
           input wire [7:0] control,
           output reg [10:0] x_paddle
       );

integer counter;
integer dx;
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        x_paddle <= 400;
        counter <= 0;
    end
    else begin
        if(counter == 99998) begin
            counter <= counter + 1;
            if(control > 8'b10000000 && control <= 8'b11000000) begin
                dx <= 1;
            end
            else if(control > 8'b11000000) begin
                dx <= 2;
            end
            else if(control < 8'b10000000 && control >= 8'b01000000) begin
                dx <= -1;
            end
            else if(control < 8'b01000000) begin
                dx <= -2;
            end
            else
                dx <= 0;
        end
        else if(counter == 99999) begin
            counter <= 0;
            if(x_paddle + dx <= length + 1) begin
                x_paddle <= length + 1;
            end
            else if(x_paddle + dx + length >= 800) begin
                x_paddle <= 800 - length;
            end
            else begin
                x_paddle <= x_paddle + dx;
            end
        end
        else
            counter <= counter + 1;
    end
end

endmodule
