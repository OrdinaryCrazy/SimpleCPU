`timescale 1ns / 1ps
`include "ALUInst.v" 
module ALU (
//----------------------------------------
    input       [31:0]  SourceA,
    input       [31:0]  SourceB,
    input       [3:0]   Ctrl,
    output  reg [31:0]  ALUOut,
    output              Zero    //
//----------------------------------------
    );
//----------------------------------------
assign Zero = (ALUOut == 0);
always@(*)
    begin
        case (Ctrl)
            `ALU_AND    : ALUOut <= SourceA & SourceB;
            `ALU_OR     : ALUOut <= SourceA | SourceB;
            `ALU_ADD    : ALUOut <= SourceA + SourceB;
            `ALU_SUB    : ALUOut <= SourceA - SourceB;
            `ALU_LT     : ALUOut <= SourceA < SourceB;
            `ALU_NOR    : ALUOut <= ~(SourceA | SourceB);
            `ALU_XOR    : ALUOut <= SourceA ^ SourceB;
            default     : ALUOut <= 32'b0;
        endcase
    end
//----------------------------------------
endmodule