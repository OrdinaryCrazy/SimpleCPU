`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/28 19:13:28
// Design Name: 
// Module Name: SORT
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

module SORT(
    //====================================================================
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    input rst,
    input clk,
    //====================================================================
    output reg [3:0] s0,
    output reg [3:0] s1,
    output reg [3:0] s2,
    output reg [3:0] s3,
    output reg done
    //====================================================================
    );
    reg [1:0] cmp_count;
    // cmp_count
    always@(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    cmp_count <= 2'b00;
                    done <= 0;
                end
            else if(cmp_count == 2'b10)
                begin
                    cmp_count <= 2'b00;
                    done <= 1;
                end
            else
                begin
                    cmp_count <= cmp_count + 2'b01;
                end
        end
    //====================================================================
    // compare
    always@(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    {s0[3:0],s1[3:0],s2[3:0],s3[3:0]} <= {x0[3:0],x1[3:0],x2[3:0],x3[3:0]};
                end
            else
                begin
                    case(cmp_count)
                        2'b00:
                            begin
                                {s0[3:0], s1[3:0]} <= (s0[3:0] > s1[3:0]) ? {s0[3:0], s1[3:0]} : {s1[3:0], s0[3:0]};
                                {s2[3:0], s3[3:0]} <= (s2[3:0] > s3[3:0]) ? {s2[3:0], s3[3:0]} : {s3[3:0], s2[3:0]};
                            end
                        2'b01:
                            begin
                                {s0[3:0], s2[3:0]} <= (s0[3:0] > s2[3:0]) ? {s0[3:0], s2[3:0]} : {s2[3:0], s0[3:0]};
                                {s1[3:0], s3[3:0]} <= (s1[3:0] > s3[3:0]) ? {s1[3:0], s3[3:0]} : {s3[3:0], s1[3:0]};
                            end
                        2'b10:
                            begin
                                {s1[3:0], s2[3:0]} <= (s1[3:0] > s2[3:0]) ? {s1[3:0], s2[3:0]} : {s2[3:0], s1[3:0]};
                            end
                    endcase
                end
        end
    //====================================================================
endmodule