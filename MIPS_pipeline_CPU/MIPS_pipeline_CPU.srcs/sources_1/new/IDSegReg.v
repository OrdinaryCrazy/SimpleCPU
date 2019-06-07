`timescale 1ns / 1ps
module IDSegReg (
//--------------------------------------------------------
    input               clk,
    input               rst,
    input               clear,
    input               en,
    input       [31:0]  Address,
    input       [31:0]  PCF,
//--------------------------------------------------------
    output  reg [31:0]  Inst,
    output  reg [31:0]  PCD
//--------------------------------------------------------
);

reg             stallOrClear;
reg     [31:0]  stallOrClearData;
wire    [31:0]  InstRaw;

// assign Inst = stallOrClear ? stallOrClearData : InstRaw;
always @(posedge clk) begin
    Inst <= stallOrClear ? stallOrClearData : InstRaw;
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stallOrClear        <= 1'b0;
        stallOrClearData    <= 32'b0;
    end else begin
        if (~en) begin
            stallOrClear        <= 1'b1;
            stallOrClearData    <= Inst;
        end else if (clear) begin
            stallOrClear        <= 1'b1;
            stallOrClearData    <= 32'b0;
        end else begin
            stallOrClear        <= 1'b0;
            stallOrClearData    <= 32'b0;
        end
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        PCD <= 32'b0;
    end else begin
        PCD <= clear ? 32'b0 : PCF;
    end
end

dist_mem_gen_0 instruction_memory (
  .a(Address[9:2]), // input wire [7 : 0] a
  .d(32'b0),        // input wire [31 : 0] d
  .dpra(8'b0),      // input wire [7 : 0] dpra
  .clk(clk),        // input wire clk
  .we(1'b0),        // input wire we
  .spo(InstRaw),    // output wire [31 : 0] spo
  .dpo(dpo)         // output wire [31 : 0] dpo
);
endmodule