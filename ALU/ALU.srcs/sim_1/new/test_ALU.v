`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/23 23:09:10
// Design Name: 
// Module Name: test_ALU
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


module test_ALU(

    );
    reg [5:0] a,b;
    reg [2:0] s;
    wire [5:0] y;
    wire [2:0] f;
    ALU alu( .a(a), .b(b), .s(s), .y(y), .f(f));
    initial
        begin
            a = 6'b010_000;
            b = 6'b010_000;
            //signed overflow
            s = 3'b000;
            #10;
            //zero
            s = 3'b001;
            #10;
            s = 3'b010;
            #10;
            s = 3'b011;
            #10;
            s = 3'b100;
            #10;
            s = 3'b101;
            #10;
            a = 6'b000_011;
            b = 6'b000_100;
            //carry flag
            s = 3'b000;
            #10;
            //-1(111_111)
            s = 3'b001;
            #10;
            s = 3'b010;
            #10;
            s = 3'b011;
            #10;
            s = 3'b100;
            #10;
            s = 3'b101;
            #10;
        end
endmodule
