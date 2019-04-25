`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 18:36:16
// Design Name: 
// Module Name: RegisterFile
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

module RegisterFile(
    input clk,
    input rst,
    input [2:0] ra0,
    input [2:0] ra1,
    input [2:0] wa,
    input [3:0] wd,
    input we,
    output [3:0] rd0,
    output [3:0] rd1
    );
reg [3:0] RegFile[7:0];
integer i;
always @ (posedge clk or posedge rst)
    begin
      if(rst)       for (i = 0; i < 8; i = i + 1) begin RegFile[i][3:0] <= 4'b0; end
      else if(we)   RegFile[wa][3:0] <= wd;
      else          RegFile[wa][3:0] <= RegFile[wa][3:0];
    end
assign rd0 = RegFile[ra0];
assign rd1 = RegFile[ra1];

endmodule
