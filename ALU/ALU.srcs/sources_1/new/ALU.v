`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/20 22:18:11
// Design Name: 
// Module Name: ALU
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


module ALU(
    input signed [5:0] a,
    input signed [5:0] b,
    input [2:0] s,
    output reg [5:0] y,
    output reg [2:0] f
    );
    //f[0]:ZF
    //f[1]:CF
    //f[2]:VF

    parameter ADD = 3'b000;
    parameter SUB = 3'b001;
    parameter AND = 3'b010;
    parameter OR  = 3'b011;
    parameter NOT = 3'b100;
    parameter XOR = 3'b101;
    parameter LENGTH = 6;
    reg carry;
    
    always @(*) begin
        case(s)
            ADD: 
                begin
                    {carry,y} = {1'b0,a} + {1'b0,b};
                    f[0] = ~(|y);
                    f[1] = carry;
                    f[2] = carry ^ a[LENGTH - 1] ^ b[LENGTH - 1] ^ y[LENGTH - 1];
                end
            SUB: 
                begin
                    {carry,y} = {1'b0,a} - {1'b0,b};
                    f[0] = ~(|y);
                    f[1] = carry;
                    f[2] = carry ^ a[LENGTH - 1] ^ b[LENGTH - 1] ^ y[LENGTH - 1];
                end
            AND:        begin y = a & b;    f = 0;  end
            OR:         begin y = a | b;    f = 0;  end
            NOT:        begin y = ~a;       f = 0;  end
            XOR:        begin y = a ^ b;    f = 0;  end
            default:    begin y = 0;        f = 0;  end
        endcase
    end
endmodule
















