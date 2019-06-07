`timescale 1ns / 1ps
module WBSegReg (
//--------------------------------------------------------
    input               clk,
    input               en,
    input               clear,
//--------------------------------------------------------
    input       [31:0]  Address,
    input       [31:0]  WriteData,
    input       [31:0]  WriteEn,
    output      [31:0]  ReadData,
    input       [7:0]   addr,
    output      [31:0]  mem_data,
    input       [31:0]  ResultM,
    output  reg [31:0]  ResultW,
    input       [4:0]   RegDestinationM,
    output  reg [4:0]   RegDestinationW,
    input               RegWriteM,
    output  reg         RegWriteW,
    input               MemtoRegM,
    output  reg         MemtoRegW
//--------------------------------------------------------
);

always @(posedge clk) begin
    if (en) begin
        if (clear) begin
            RegWriteW       <= 1'b0;
            MemtoRegW       <= 1'b0;
            RegDestinationW <= 5'b0;
            ResultW         <= 32'b0;
        end else begin
            RegWriteW       <= RegWriteM;
            MemtoRegW       <= MemtoRegM;
            RegDestinationW <= RegDestinationM;
            ResultW         <= ResultM;
        end
    end
end

wire [31:0] ReadData_Raw;
dist_mem_gen_0 data_memory (
    .a(Address[9:2]),   // input wire [7 : 0] a
    .d(WriteData),      // input wire [31 : 0] d
    .dpra(addr),        // input wire [7 : 0] dpra
    .clk(clk),          // input wire clk
    .we(WriteEn),       // input wire we
    .spo(ReadData),     // output wire [31 : 0] spo
    .dpo(mem_data)      // output wire [31 : 0] dpo
);

reg         stall_buf;
reg         clear_buf;
reg [31:0]  ReadData_Old;
always @(posedge clk) begin
    stall_buf       <= ~en;
    clear_buf       <= clear;
    ReadData_Old    <= ReadData_Raw;
end

assign ReadData = stall_buf ? ReadData_Old : 
                            ( clear_buf ? 32'b0 : ReadData_Raw);

endmodule