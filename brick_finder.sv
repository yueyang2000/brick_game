//接受x,y屏幕坐标返回50*100网格的区域位置bx,by
module brick_finder(
           input wire [10:0] x,
           input wire [9:0] y,
           output reg [3:0] bx,
           output reg [3:0] by,
           output reg [10:0] x_start,
           output reg [9:0] y_start
       );

always @(*) begin
    if(x>400) begin
        if(x>600) begin
            if(x>700) begin
                bx<= 7;
                x_start<= 701;
            end
            else begin
                bx <= 6;
                x_start <= 601;
            end
        end
        else begin
            if(x>500) begin
                bx <= 5;
                x_start <= 501;
            end
            else begin
                bx <= 4;
                x_start <= 401;
            end
        end
    end
    else begin
        if(x>200) begin
            if(x>300) begin
                bx <= 3;
                x_start <= 301;
            end
            else begin
                bx <= 2;
                x_start <= 201;
            end
        end
        else begin
            if(x>100) begin
                bx <= 1;
                x_start <= 101;
            end
            else begin
                bx <= 0;
                x_start <= 1;
            end
        end
    end
end
always @(*) begin
    if(y>300) begin
        if(y>450) begin
            if(y>550) begin
                by <= 11;
                y_start <= 551;
            end
            else if(y>500) begin
                by <= 10;
                y_start <= 501;
            end
            else begin
                by <= 9;
                y_start <= 451;
            end
        end
        else begin
            if(y>400) begin
                by <= 8;
                y_start <= 401;
            end
            else if(y>350) begin
                by <= 7;
                y_start <= 351;
            end
            else begin
                by <= 6;
                y_start <= 301;
            end
        end
    end
    else begin
        if(y>150) begin
            if(y>250) begin
                by <= 5;
                y_start <= 251;
            end
            else if(y>200) begin
                by <= 4;
                y_start <= 201;
            end
            else begin
                by <= 3;
                y_start <= 151;
            end
        end
        else begin
            if(y>100) begin
                by <= 2;
                y_start <= 101;
            end
            else if(y>50) begin
                by <= 1;
                y_start <= 51;
            end
            else begin
                by <= 0;
                y_start <= 1;
            end
        end
    end
end

endmodule
