`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/14 20:38:32
// Design Name: 
// Module Name: ALUControl
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

`include "ALUInst.v"
module ALUControl(
//----------------------------------------
    input       [1:0]   ALUOp,
    input       [5:0]   Func,
    output  reg [3:0]   Ctrl
//----------------------------------------
    );
//----------------------------------------
always@(*) 
begin
    case (ALUOp)
        2'b00   :
        //----------------------------------------
            begin
                Ctrl <= `ALU_ADD;
            end
        //----------------------------------------
        2'b01   :
        //----------------------------------------
            begin
                Ctrl <= `ALU_SUB;
            end
        //----------------------------------------
        2'b10   :
            begin
                case (Func)
                
                    `FUNC_ADD   : Ctrl <= `ALU_ADD;
                    `FUNC_SUB   : Ctrl <= `ALU_SUB;
                    `FUNC_SLT   : Ctrl <= `ALU_LT;
                    `FUNC_AND   : Ctrl <= `ALU_AND;
                    `FUNC_OR    : Ctrl <= `ALU_OR;
                    `FUNC_XOR   : Ctrl <= `ALU_XOR;
                    `FUNC_NOR   : Ctrl <= `ALU_NOR;

                    `FUNC_ADDI  : Ctrl <= `ALU_ADD;
                    `FUNC_SLTI  : Ctrl <= `ALU_LT;
                    `FUNC_ANDI  : Ctrl <= `ALU_AND;
                    `FUNC_ORI   : Ctrl <= `ALU_OR;
                    `FUNC_XORI  : Ctrl <= `ALU_XOR;

                    default     : Ctrl <= 4'b1111;
                endcase
            end
        //----------------------------------------
        default :   Ctrl <= 4'b1111;
        //----------------------------------------
    endcase
end
//----------------------------------------
endmodule