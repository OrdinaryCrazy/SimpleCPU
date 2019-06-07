`timescale 1ns / 1ps
module MEMSegReg (
//--------------------------------------------------------
    input               clk,
    input               en,
    input               clear,
//--------------------------------------------------------
    input       [31:0]  PCE,
    output  reg [31:0]  PCM,
    input       [31:0]  ForwardDataB,
    output  reg [31:0]  StoreDataM,
    input       [31:0]  ALUOutE,
    output  reg [31:0]  ALUOutM,
    input       [31:0]  InstrE,
    output  reg [31:0]  InstrM,

    input               RegWriteE,
    output  reg         RegWriteM,
    input               MemtoRegE,
    output  reg         MemtoRegM,
    input               MemWriteE,
    output  reg         MemWriteM,
    input       [4:0]   RegDestinationE,
    output  reg [4:0]   RegDestinationM
//--------------------------------------------------------
);
always @(posedge clk) begin
    if (en) begin
        if (clear) begin
            PCM             <= 32'b0;
            ALUOutM         <= 32'b0;
            StoreDataM      <= 32'b0;
            InstrM          <= 32'b0;
            RegWriteM       <= 1'b0;
            MemtoRegM       <= 1'b0;
            MemWriteM       <= 1'b0;
            RegDestinationM <= 1'b0;
        end else begin
            PCM             <= PCE;
            ALUOutM         <= ALUOutE;
            StoreDataM      <= ForwardDataB;
            InstrM          <= InstrE;
            RegWriteM       <= RegWriteE;
            MemtoRegM       <= MemtoRegE;
            MemWriteM       <= MemWriteE;
            RegDestinationM <= RegDestinationE;
        end
    end
end
endmodule
