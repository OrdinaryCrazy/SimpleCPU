`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 20:35:26
// Design Name: 
// Module Name: test_sort
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


module test_sort(

    );
    reg [3:0] x0,x1,x2,x3;
    reg rst,clk;
    wire [3:0] s0,s1,s2,s3;
    wire done;
    SORT s(.x0(x0),.x1(x1),.x2(x2),.x3(x3),.rst(rst),.clk(clk),.s0(s0),.s1(s1),.s2(s2),.s3(s3),.done(done));
    initial
        begin
            x0 = 4'd3;
            x1 = 4'd5;
            x2 = 4'd1;
            x3 = 4'd10;
            rst = 0;
            clk = 0;
            #5
            rst = 1;
            clk = 1;
            #5
            rst = 0;
            clk = 0;
            #5
            clk = 1;
            #5
            clk = 0;
            #5
            clk = 1;
            #5
            clk = 0;
            #5
            clk = 1;
            #5
            clk = 0;
            #5
            clk = 1;
            #5
            clk = 0;
            #5
            clk = 1;
        end
endmodule
