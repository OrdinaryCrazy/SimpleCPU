`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 18:36:48
// Design Name: 
// Module Name: Counter
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


module Counter(
    input ce,
    input pe,
    input rst,
    input clk,
    input [23:0] d,
    output reg [23:0] q
    );
always @( posedge clk or posedge rst) 
    begin
        if(rst)         q <= 24'b0;
        else if (pe)    q <= d;
        else if (ce)    q <= q + 24'd1;
        else            q <= q;
    end
endmodule
