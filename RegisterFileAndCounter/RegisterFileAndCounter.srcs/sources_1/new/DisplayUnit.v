`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 19:43:22
// Design Name: 
// Module Name: DisplayUnit
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


module DisplayUnit(
    input validFlag,
    input [3:0] number,
    input [2:0] position,
    input headdot,
    output reg [7:0] sel,
    output reg [7:0] seg
    );
always @ (*)
    begin
        seg[7] = ~headdot;
        if(~validFlag)
            seg[6:0] = 7'b1111_111;
        else
            begin
                case(number)
                    //                     gfed_cba
                    4'b0000: seg[6:0] = 7'b1000_000;
                    //                     gfed_cba
                    4'b0001: seg[6:0] = 7'b1111_001;
                    //                     gfed_cba
                    4'b0010: seg[6:0] = 7'b0100_100;
                    //                     gfed_cba
                    4'b0011: seg[6:0] = 7'b0110_000;
                    //                     gfed_cba
                    4'b0100: seg[6:0] = 7'b0011_001;
                    //                     gfed_cba
                    4'b0101: seg[6:0] = 7'b0010_010;
                    //                     gfed_cba
                    4'b0110: seg[6:0] = 7'b0000_010;
                    //                     gfed_cba
                    4'b0111: seg[6:0] = 7'b1111_000;
                    //                     gfed_cba
                    4'b1000: seg[6:0] = 7'b0000_000;
                    //                     gfed_cba
                    4'b1001: seg[6:0] = 7'b0010_000;
                    //                     gfed_cba
                    4'b1010: seg[6:0] = 7'b0001_000;
                    //                     gfed_cba
                    4'b1011: seg[6:0] = 7'b0000_011;
                    //                     gfed_cba
                    4'b1100: seg[6:0] = 7'b1000_110;
                    //                     gfed_cba
                    4'b1101: seg[6:0] = 7'b0100_001;
                    //                     gfed_cba
                    4'b1110: seg[6:0] = 7'b0000_110;
                    //                     gfed_cba
                    4'b1111: seg[6:0] = 7'b0001_110;
                endcase
            end
        
        case(position)
            3'b000: sel = 8'b1111_1110;
            3'b001: sel = 8'b1111_1101;
            3'b010: sel = 8'b1111_1011;
            3'b011: sel = 8'b1111_0111;
            3'b100: sel = 8'b1110_1111;
            3'b101: sel = 8'b1101_1111;
            3'b110: sel = 8'b1011_1111;
            3'b111: sel = 8'b0111_1111;
        endcase
    end
endmodule
