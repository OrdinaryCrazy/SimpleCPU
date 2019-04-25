`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/15 00:00:33
// Design Name: 
// Module Name: VGADrawer
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


module VGADrawer
(
//---------------------------------------------------------------------
    input           clk     ,
    input           rst     ,
    input   [11:0]  rgb     ,
    input   [3:0]   dir     ,
    input           draw    ,
//---------------------------------------------------------------------
    output          hs      ,
    output          vs      ,
    output  [11:0]  vrgb
//---------------------------------------------------------------------    
);
wire [15:0] paddr   ;
wire [11:0] pdata   ;
wire        we      ;
wire [7:0]  x       ;
wire [7:0]  y       ;
wire [15:0] vaddr   ;
wire [11:0] vdata   ;
//---------------------------------------------------------------------
DCU dcu_1
(
    .clk(clk)           ,
    .rst(rst)           ,
    .x(x)               ,
    .y(y)               ,
    .vdata(vdata)       ,
    .hs(hs)             ,
    .vs(vs)             ,
    .red  ( vrgb[ 3:0] ),
    .green( vrgb[ 7:4] ),
    .blue ( vrgb[11:8] ),
    .vaddr(vaddr)
);
//---------------------------------------------------------------------
PCU pcu_1
(
    .clk(clk)       ,
    .rst(rst)       ,
    .rgb(rgb)       ,
    .dir(dir)       ,
    .draw(draw)     ,
    .x(x)           ,
    .y(y)           ,  
    .we(we)         ,
    .paddr(paddr)   ,
    .pdata(pdata)    
);
//---------------------------------------------------------------------
VRAM vram_1
(
    .clk(clk)       ,
    .rst(rst)       ,
    .paddr(paddr)   ,
    .pdata(pdata)   ,
    .we(we)         ,
    .vaddr(vaddr)   ,
    .vdata(vdata)
);
//---------------------------------------------------------------------
endmodule
