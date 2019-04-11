`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 23:18:47
// Design Name: 
// Module Name: test_div
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


module test_div(

    );
    reg [3:0] x,y;
    reg rst;
    reg clk;
    reg input_confer;
    wire [3:0] q,r;
    wire error, done;
    DIV d(.x(x), .y(y), .rst(rst), .clk(clk), .input_confer(input_confer), .q(q), .r(r), .error(error), .done(done));
    initial
        begin
            x = 4'd11;
            y = 4'd5;
            input_confer = 1;
            clk = 0;
            rst = 0;
            #5
            clk = 1;
            rst = 1;
            #5
            clk = 0;
            rst = 0;
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
            #5
            clk = 0;
            #5
            clk = 1;
            #5
            //=====================================
            x = 4'd8;
            y = 4'd8;
            clk = 0;
            rst = 0;
            #5
            clk = 1;
            rst = 1;
            #5
            clk = 0;
            rst = 0;
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
        end
endmodule
