`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/24 21:43:23
// Design Name: 
// Module Name: test_fibonacci
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


module test_fibonacci(

    );
    reg [5:0] a,b,reset,clk;
    wire [5:0]result;
    fibonacci tf(.a(a),.b(b),.reset(reset),.clk(clk),.result(result));
    initial
        begin
            a = 6'b000_001;
            b = 6'b000_000;
            reset = 0;
            clk = 0;
            #10
            reset = 1;
            clk = 1;
            #10
            reset = 0;
            clk = 0;
            #10
            clk = 1;
            #10
            clk = 0;
            #10
            clk = 1;
            #10
            clk = 0;
            #10
            clk = 1;
            #10
            clk = 0;
            #10
            clk = 1;
            #10
            clk = 0;
            #10
            clk = 1;
            #10
            clk = 0;
            #10
            clk = 1;
            #10
            clk = 0;
            #10
            clk = 1;
            #10
            clk = 0;
            #10
            clk = 1;
        end        
endmodule














