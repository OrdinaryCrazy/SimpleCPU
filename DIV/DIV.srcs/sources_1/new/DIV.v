`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 09:40:33
// Design Name: 
// Module Name: DIV
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DIV(
    input[3:0] x,
    input[3:0] y,
    input rst,
    input clk,
    input input_confer,
    output reg [3:0] q,
    output reg [3:0] r,
    output reg error,
    output reg done
);
    reg [3:0] tempx;
    reg [3:0] tempy;
    reg [7:0] temp_x;
    reg [7:0] temp_y;
    reg [3:0] div_count;
    reg div_on_going;
    //-----------------------------------------------
    //division vaild
    always@(*) 
        begin
            error = ~(|y);
        end
    //-----------------------------------------------
    //operator store
    always@(posedge clk or posedge rst)
        begin
            if(rst)                 begin   tempx <= 4'b0;  tempy <= 4'b0;  end
            else if(input_confer)   begin   tempx <= x;     tempy <= y;     end
            else                    begin   tempx <= tempx; tempy <= tempy; end
        end
    //-----------------------------------------------
    //division on going flag
    always@(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    div_on_going <= 1'b0;
                    done <= 1'b0;
                end
            else if(input_confer && div_on_going == 1'b0)
                div_on_going <= 1'b1;
            else if(div_count == 4'd8)
                begin
                    div_on_going <= 1'b0;
                    done <= 1'b1;
                end
            else
                div_on_going <= div_on_going;
        end
    //-----------------------------------------------
    //division counter
    always@(posedge clk or posedge rst)
        begin
            if(rst)                 div_count <= 4'b0;
            else if(div_on_going)   div_count <= div_count + 4'b1;
            else                    div_count <= 4'b0;
        end
    //------------------------------------------------
    //division
    always@(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    temp_x = 8'b0;
                    temp_y = 8'b0;
                end
            else if(div_on_going)
                begin
                    if(div_count == 4'b0)
                        begin
                            temp_x <= {4'b0,tempx};
                            temp_y <= {tempy,4'b0};
                        end
                    else if(div_count[0] == 1'b1)
                        temp_x <= {temp_x[6:0],1'b0};
                    else
                        temp_x <= (temp_x[7:4] >= temp_y[7:4]) ? (temp_x - temp_y + 1) : temp_x;
                end
            else
                begin
                    temp_x = 8'b0;
                    temp_y = 8'b0;
                end
        end
    //------------------------------------------------
    //result output
    always@(posedge done or posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    q = 4'b0;
                    r = 4'b0;
                end
            else if(done)
                begin
                    q = temp_x[3:0];
                    r = temp_x[7:4];
                end
            else
                begin
                    q = 4'b0;
                    r = 4'b0;
                end
        end
    //------------------------------------------------
endmodule



















