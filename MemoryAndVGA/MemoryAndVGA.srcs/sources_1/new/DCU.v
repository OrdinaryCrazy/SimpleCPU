`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/13 23:05:27
// Design Name: 
// Module Name: DCU
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


module DCU
(
//---------------------------------------------------------------------
    input               clk     ,
    input               rst     ,
    input       [7:0]   x       ,
    input       [7:0]   y       ,
    input       [11:0]  vdata   ,
//---------------------------------------------------------------------
    output              hs      ,
    output              vs      ,
    output  reg [3:0]   red     ,
    output  reg [3:0]   blue    ,
    output  reg [3:0]   green   ,
    output  reg [15:0]  vaddr   
//---------------------------------------------------------------------
);
//---------------------------------------------------------------------
// 分辨率为800*600，刷新频率72Hz，像素时钟50MHz，行时序参数定义，行的单位是“标准时钟周期”
parameter   Horizontal_Sync_Pulse   =   120 ,   // 行同步宽度
            Horizontal_Back_Porch   =   64  ,   // 行消隐宽度
            Horizontal_Front_Porth  =   56  ,   // 行前肩宽度
            Horizontal_Active_Time  =   800 ,   // 行视频有效宽度
            Horizontal_Line_Period  =   1040;   // 行宽度
//---------------------------------------------------------------------
// 分辨率为800*600，刷新频率72Hz，像素时钟50MHz，场时序参数定义，场的单位是“行周期”
parameter   Vertical_Sync_Pulse     =   6   ,   // 场同步宽度
            Vertical_Back_Porch     =   23  ,   // 场消隐宽度
            Vertical_Front_Porth    =   37  ,   // 场前肩宽度
            Vertical_Active_Time    =   600 ,   // 场视频有效宽度
            Vertical_Frame_Period   =   666 ;   // 场宽度
//---------------------------------------------------------------------
reg [11:0]  H_Count     ;   // 行时序计数器
reg [11:0]  V_Count     ;   // 场时序计数器
reg         Pixel_Clk   ;   // 50MHz像素时钟   
wire        Active_Flag ;   // 显示激活标志
wire        Cross_Sign  ;   // 十字光标区域标志
//--------------------------------------------------------------------------------------------------------------------------
assign  Active_Flag =   (H_Count >= (Horizontal_Sync_Pulse  + Horizontal_Back_Porch                              ))  &&
                        (H_Count <= (Horizontal_Sync_Pulse  + Horizontal_Back_Porch + Horizontal_Active_Time     ))  &&
                        (V_Count >= (Vertical_Sync_Pulse    + Vertical_Back_Porch                                ))  &&
                        (V_Count <= (Vertical_Sync_Pulse    + Vertical_Back_Porch   + Vertical_Active_Time       ))  ;
//--------------------------------------------------------------------------------------------------------------------------
assign  Show_Flag =     (H_Count >= (Horizontal_Sync_Pulse  + Horizontal_Back_Porch         ))  &&
                        (H_Count <= (Horizontal_Sync_Pulse  + Horizontal_Back_Porch + 255   ))  &&
                        (V_Count >= (Vertical_Sync_Pulse    + Vertical_Back_Porch           ))  &&
                        (V_Count <= (Vertical_Sync_Pulse    + Vertical_Back_Porch   + 255   ))  ;
//--------------------------------------------------------------------------------------------------------------------------
assign  Cross_Sign  =   (
                            (H_Count <= (Horizontal_Sync_Pulse + Horizontal_Back_Porch + x + 5   )) &&
                            (H_Count >= (Horizontal_Sync_Pulse + Horizontal_Back_Porch + x - 5   )) &&
                            (V_Count == (Vertical_Sync_Pulse   + Vertical_Back_Porch   + y       ))
                        )   ||
                        (  
                            (H_Count == (Horizontal_Sync_Pulse + Horizontal_Back_Porch + x       )) &&
                            (V_Count >= (Vertical_Sync_Pulse   + Vertical_Back_Porch   + y - 7   )) &&
                            (V_Count <= (Vertical_Sync_Pulse   + Vertical_Back_Porch   + y + 7   ))
                        );
//--------------------------------------------------------------------------------------------------------------------------
// 产生50MHz像素时钟
always @ (posedge clk)   begin   Pixel_Clk   <=  ~Pixel_Clk  ;   end
//--------------------------------------------------------------------------------------------------------------------------
// 产生行时序
always @ (posedge Pixel_Clk or posedge rst)
begin
    if (rst)                                            H_Count <=  12'd0           ;
    else if (H_Count == Horizontal_Line_Period - 1'b1)  H_Count <=  12'd0           ;
    else                                                H_Count <=  H_Count + 12'd1 ;
end
//--------------------------------------------------------------------------------------------------------------------------
// 产生场时序
always @ (posedge Pixel_Clk or posedge rst)
begin
    if (rst)                                            V_Count <=  12'd0           ;
    else if (V_Count == Vertical_Frame_Period  - 1'b1)  V_Count <=  12'd0           ;
    else if (H_Count == Horizontal_Line_Period - 1'b1)  V_Count <=  V_Count + 1'b1  ;
    else                                                V_Count <=  V_Count         ;
end
//--------------------------------------------------------------------------------------------------------------------------
assign hs = (H_Count < Horizontal_Sync_Pulse) ? 1'b0 : 1'b1 ;
assign vs = (V_Count < Vertical_Sync_Pulse  ) ? 1'b0 : 1'b1 ;
//--------------------------------------------------------------------------------------------------------------------------
// 产生视频显示
always @ (posedge Pixel_Clk or posedge rst)
begin
    if (rst)                vaddr <= 16'd0;
    else if (Active_Flag)
        begin
            if (Show_Flag)
                begin
                    if (Cross_Sign)
                        begin
                            red   <= 4'b0000        ;   
                            green <= 4'b1111        ;   
                            blue  <= 4'b0000        ;
                            vaddr <= vaddr + 1'b1   ;   
                        end
                    else
                        begin
                            red   <= vdata[ 3:0]    ;   
                            green <= vdata[ 7:4]    ;   
                            blue  <= vdata[11:8]    ;
                            vaddr <= vaddr + 1'b1   ;   
                        end
                end
            else
                begin
                    red     <=  4'b0000 ;
                    green   <=  4'b0000 ;
                    blue    <=  4'b0000 ;
                    vaddr   <=  vaddr   ;
                end
        end
    else
        begin
            red     <=  4'b0000 ;
            green   <=  4'b0000 ;
            blue    <=  4'b0000 ;
            vaddr   <=  vaddr   ;
        end
end
//---------------------------------------------------------------------
endmodule
