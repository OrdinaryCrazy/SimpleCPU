`timescale 1ns / 1ps
module EXSegReg (
//--------------------------------------------------------
    input               clk,
    input               en,
    input               clear,
//--------------------------------------------------------
    input       [31:0]  PCD,
    output  reg [31:0]  PCE,
    input       [31:0]  ImmD,
    output  reg [31:0]  ImmE,
    input       [31:0]  InstrD,
    output  reg [31:0]  InstrE,
    input       [31:0]  RegDataAD,
    output  reg [31:0]  RegDataAE,
    input       [31:0]  RegDataBD,
    output  reg [31:0]  RegDataBE,

    input               RegDstD,
    output  reg         RegDstE,
    input               RegWriteD,
    output  reg         RegWriteE,
    input               ALUSrcAD,
    output  reg         ALUSrcAE,
    input       [1:0]   ALUSrcBD,
    output  reg [1:0]   ALUSrcBE,
    input               MemReadD,
    output  reg         MemReadE,
    input               MemWriteD,
    output  reg         MemWriteE,
    input               MemtoRegD,
    output  reg         MemtoRegE,
    input       [3:0]   ALUCtrlD,
    output  reg [3:0]   ALUCtrlE,
    input       [1:0]   RegReadD,
    output  reg [1:0]   RegReadE
//--------------------------------------------------------
);
always @(posedge clk) begin
    if (en) begin
        if (clear) begin
            PCE         <= 32'b0;
            ImmE        <= 32'b0;
            InstrE      <= 32'b0;
            RegDataAE   <= 32'b0;
            RegDataBE   <= 32'b0;

            RegDstE     <= 1'b0;
            RegWriteE   <= 1'b0;
            ALUSrcAE    <= 1'b0;
            ALUSrcBE    <= 2'b00;
            MemReadE    <= 1'b0;
            MemWriteE   <= 1'b0;
            MemtoRegE   <= 1'b0;
            ALUCtrlE    <= 4'b0;
            RegReadE    <= 2'b00;
        end else begin
            PCE         <= PCD;
            ImmE        <= ImmD;
            InstrE      <= InstrD;
            RegDataAE   <= RegDataAD;
            RegDataBE   <= RegDataBD;

            RegDstE     <= RegDstD;
            RegWriteE   <= RegWriteD;
            ALUSrcAE    <= ALUSrcAD;
            ALUSrcBE    <= ALUSrcBD;
            MemReadE    <= MemReadD;
            MemWriteE   <= MemWriteD;
            MemtoRegE   <= MemtoRegD;
            ALUCtrlE    <= ALUCtrlD;
            RegReadE    <= RegReadD;
        end
    end
end
endmodule
