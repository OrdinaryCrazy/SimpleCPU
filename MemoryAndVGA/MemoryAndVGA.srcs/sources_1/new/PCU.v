`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/13 23:04:47
// Design Name: 
// Module Name: PCU
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


module PCU
(
//---------------------------------------------------------------------
    input               clk     ,
    input               rst     ,
    input       [11:0]  rgb     ,
    // rgb[ 3:0] := red  [3:0],
    // rgb[ 7:4] := green[3:0],
    // rgb[11:8] := blue [3:0],
    input       [3:0]   dir     ,
    // dir[0] := Up,    dir[1] := Left, 
    // dir[2] := Down,  dir[3] := Right,
    input               draw    ,
//---------------------------------------------------------------------
    output  reg [7:0]   x       ,
    output  reg [7:0]   y       ,
    output              we      ,
    output  reg [15:0]  paddr   ,
    output  reg [11:0]  pdata   
//---------------------------------------------------------------------
);
//---------------------------------------------------------------------
reg         clk_slow    ;   initial clk_slow  =  1'b0;
reg [23:0]  clk_count   ;   initial clk_count = 24'd0;
reg         Pixel_Clk   ;   // 50MHz像素时钟
//---------------------------------------------------------------------
// 产生50MHz像素时钟
always @ (posedge clk)   begin   Pixel_Clk   <=  ~Pixel_Clk  ;   end
//---------------------------------------------------------------------
always @ (posedge Pixel_Clk)
    begin
        if (clk_count == 24'd100_0000 - 24'd1)  begin   clk_slow <= 1'b1;   clk_count <= 24'd0;             end
        else                                    begin   clk_slow <= 1'b0;   clk_count <= clk_count + 24'd1; end
    end
//---------------------------------------------------------------------
assign we = draw & clk_slow;
//---------------------------------------------------------------------
always @ (posedge clk_slow or posedge rst)
    begin
    //---------------------------------------------------------------------
        if(rst)                 begin   x <= 8'd128;    y <= 8'd128;    end
    //---------------------------------------------------------------------
        else 
            begin
                case (dir)
                    4'b0001:    begin   x <= x + 8'd0;  y <= y - 8'd1;  end // Up
                    4'b0010:    begin   x <= x - 8'd1;  y <= y + 8'd0;  end // Left
                    4'b0100:    begin   x <= x + 8'd0;  y <= y + 8'd1;  end // Down
                    4'b1000:    begin   x <= x + 8'd1;  y <= y + 8'd0;  end // Right
                    4'b1001:    begin   x <= x + 8'd1;  y <= y - 8'd1;  end // UpRight
                    4'b0011:    begin   x <= x - 8'd1;  y <= y - 8'd1;  end // UpLeft
                    4'b0110:    begin   x <= x - 8'd1;  y <= y + 8'd1;  end // DownLeft
                    4'b1100:    begin   x <= x + 8'd1;  y <= y + 8'd1;  end // DownRight
                    default:    begin   x <= x + 8'd0;  y <= y + 8'd0;  end // Illegal
                endcase
            end
    //---------------------------------------------------------------------
        paddr[15:0] <= {y[7:0], x[7:0]} ; 
        pdata[11:0] <= rgb[11:0]        ;
    //---------------------------------------------------------------------
    end
//---------------------------------------------------------------------
endmodule
