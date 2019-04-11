`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/22 19:01:21
// Design Name: 
// Module Name: fibonacci
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


module fibonacci(
    input[5:0] a,
    input[5:0] b,
    input reset,
    input clk,
    output reg [5:0] result
    //output newclk
    );
    wire[2:0] flag;
    wire[5:0] inerResult;
    wire[5:0] input1;
    wire[5:0] input2;
    //wire newclk;
    reg[5:0] tmp1;
    reg[5:0] tmp2;
    assign input1 = tmp1;
    assign input2 = tmp2;
    //clkadaptor c(clk,newclk);
    /**
    module ALU(
    input signed [5:0] a,
    input signed [5:0] b,
    input [2:0] s,
    output reg [5:0] y,
    output reg [2:0] f
    );
    **/
    ALU alu(input1,input2,3'b000,inerResult,flag);
    always@(posedge reset, posedge clk)
    begin
        if(reset)
            begin
                tmp1 <= a>b?b:a;
                tmp2 <= a>b?a:b;
                result <= 0;
            end
        if(clk)
            begin
                result = inerResult;
                tmp1 = tmp2;
                tmp2 = inerResult;
            end
    end
    
endmodule
