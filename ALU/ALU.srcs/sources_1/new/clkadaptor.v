`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/22 19:19:19
// Design Name: 
// Module Name: clkadaptor
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


module clkadaptor(
    input originClk,
    output reg resultClk
    );
    reg[31:0] count;
    initial count = 0;
    always@(posedge originClk) begin
        if(count==32'd100_000_000)
            resultClk <= 1;
        else
            begin
                resultClk <= 0;
                count <= count + 1;
            end
    end
endmodule
