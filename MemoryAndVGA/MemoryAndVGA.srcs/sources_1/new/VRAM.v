`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/13 23:05:27
// Design Name: 
// Module Name: VRAM
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


module VRAM
(
//---------------------------------------------------------------------
    input           clk     ,
    input           rst     ,
    input   [15:0]  paddr   ,
    input   [11:0]  pdata   ,
    input           we      ,
    input   [15:0]  vaddr   ,
//---------------------------------------------------------------------
    output  [11:0]  vdata
//---------------------------------------------------------------------
);
reg  [15:0] a;
wire [11:0] d;
wire we_m;
//---------------------------------------------------------------------
assign we_m = rst ? 1'b1 : we;
always @ (posedge clk) 
    begin
        if (rst)    a[15:0] <= a[15:0] + 16'd1;
        else        a[15:0] <= paddr[15:0];
    end
assign d = rst ? 12'b1111_1111_1111 : pdata[11:0];
//---------------------------------------------------------------------
dist_mem_gen_0 vram_core (
    .a(a),        // input wire [15 : 0] a
    .d(d),        // input wire [11 : 0] d
    .dpra(vaddr),     // input wire [15 : 0] dpra
    .clk(clk),        // input wire clk
    .we(we_m),        // input wire we
    .dpo(vdata)       // output wire [11 : 0] dpo
);
//---------------------------------------------------------------------
endmodule
