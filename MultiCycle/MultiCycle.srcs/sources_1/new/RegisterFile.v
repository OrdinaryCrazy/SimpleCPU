`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/14 20:38:32
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
//----------------------------------------
    input               clk,
    input               rst,
//----------------------------------------
    input               RegWrite,
    input       [4:0]   ReadAddr1,
    output      [31:0]  ReadData1,
    input       [4:0]   ReadAddr2,
    output      [31:0]  ReadData2,
    input       [4:0]   WriteAddr,
    input       [31:0]  WriteData,
//----------------------------------------
    input       [4:0]   addr,
    output      [31:0]  reg_data
//----------------------------------------
    );
//----------------------------------------
reg [31:0]  registers[0:31];
assign ReadData1 = registers[ReadAddr1];
assign ReadData2 = registers[ReadAddr2];
assign reg_data  = registers[addr];
integer i;
//----------------------------------------
always@(posedge clk or posedge rst)
    begin
        if(rst) for (i = 0; i < 32; i = i + 1)  begin registers[i][31:0] <= 32'd0;          end
        else    if(RegWrite)                    begin registers[WriteAddr] <= WriteData;    end
    end
//----------------------------------------
endmodule
