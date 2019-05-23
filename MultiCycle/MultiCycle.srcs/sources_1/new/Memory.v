`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/14 20:34:46
// Design Name: 
// Module Name: Memory
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


module Memory(
//----------------------------------------
    input               clk,
//----------------------------------------
    input               MemRead,
    input               MemWrite,
    input       [31:0]  Address,
    input       [31:0]  WriteData,
    output      [31:0]  MemData,
//----------------------------------------
//  input       [31:0]  addr,
    input       [7:0]   addr,
    output      [31:0]  mem_data
//----------------------------------------
    );
//----------------------------------------
dist_mem_gen_0 mem (
  .a(Address[9:2]),                 // input wire [7 : 0] a
  .d(WriteData),                    // input wire [31 : 0] d
  .dpra( { 2'b00, addr[7:2] } ),    // input wire [7 : 0] dpra
  .clk(clk),                        // input wire clk
  .we(MemWrite),                    // input wire we
  .spo(MemData),                    // output wire [31 : 0] spo
  .dpo(mem_data)                    // output wire [31 : 0] dpo
);
//----------------------------------------
endmodule
