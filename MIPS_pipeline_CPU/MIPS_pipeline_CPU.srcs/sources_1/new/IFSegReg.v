`timescale 1ns / 1ps
module IFSegReg (
//--------------------------------------------------------
    input               clk,
    input               rst,
    input               en,
    input   [31:0]      PC_In,
//--------------------------------------------------------
    output  reg [31:0]  PC
//--------------------------------------------------------
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        PC <= 32'd200;
    end else begin
        if (en) begin
            PC <= PC_In;
        end else begin
            PC <= PC;
        end
    end
end

endmodule