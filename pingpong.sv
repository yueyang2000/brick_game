module pingpong #(
           parameter radius = 5
       )(
           input wire clk,
           input wire rst,
           input wire [10:0] x_paddle_l,
           input wire [10:0] x_paddle_r,
           output reg [10:0] x,
           output reg [9:0] y
       );

localparam H = 800;
localparam V = 600;

integer dx, dy;
integer counter;
reg state;
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        x <= 400;
        y <= 300;
        dx <= 1;
        dy <= 1;
        counter <= 0;
        state <= 1;
    end
    else begin
        if(state == 0) begin
            x <= 400;
            y <= 300;
            dx <= 1;
            dy <= 1;
            counter <= 0;
            state <= 1;
        end
        else begin
            if(counter == 99999) begin
                counter <= 0;
                if(x + dx <= radius + 1) begin
                    dx <= -1*dx;
                    x <= radius + 1;
                end
                else if(x + dx + radius >= 800) begin
                    dx <= -1*dx;
                    x <= 800 - radius;
                end
                else begin
                    x <= x + dx;
                end
                if(y + dy <= 30 + radius) begin
                    if(x>=x_paddle_l - 60 && x <= x_paddle_l + 60) begin
                        y <= 31 + radius;
                        dy <= -1*dy;
                    end
                    else begin
                        state <= 0;
                    end
                end
                else if(y + dy >= 571-radius) begin
                    if(x>=x_paddle_r - 60 && x <= x_paddle_r + 60) begin
                        y <= 570-radius;
                        dy <= -1*dy;
                    end
                    else begin
                        state <= 0;
                    end
                end
                else
                    y <= y + dy;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end
end
endmodule
