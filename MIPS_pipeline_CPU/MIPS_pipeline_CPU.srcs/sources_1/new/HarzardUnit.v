`timescale 1ns / 1ps
module HarzardUnit (
//--------------------------------------------------------
    input               rst,
    input               BranchE,
    input               JumpD,
    input       [4:0]   RegSourceAD, 
    input       [4:0]   RegSourceBD,
    input       [4:0]   RegSourceAE, 
    input       [4:0]   RegSourceBE,
    input       [4:0]   RegDestinationE,
    input       [4:0]   RegDestinationM,
    input       [4:0]   RegDestinationW,
    input       [1:0]   RegReadE,   // 两个源寄存器的使用情况
    input               MemtoRegE,
    input               RegWriteM,
    input               RegWriteW,
//--------------------------------------------------------
    output  reg         StallF, 
    output  reg         StallD, 
    output  reg         StallE, 
    output  reg         StallM, 
    output  reg         StallW,
    output  reg         FlushF, 
    output  reg         FlushD, 
    output  reg         FlushE, 
    output  reg         FlushM, 
    output  reg         FlushW,
    output  reg [1:0]   ForwardAE, 
    output  reg [1:0]   ForwardBE
//--------------------------------------------------------
);
//--------------------------------------------------------
always @(*) begin
    if (rst) begin
        StallF <= 1'b0; FlushF <= 1'b1;
        StallD <= 1'b0; FlushD <= 1'b1;
        StallE <= 1'b0; FlushE <= 1'b1;
        StallM <= 1'b0; FlushM <= 1'b1;
        StallW <= 1'b0; FlushW <= 1'b1;
    end else if (   MemtoRegE && 
                    RegDestinationE != 5'b0 && 
                    ( RegDestinationE == RegSourceAD || RegDestinationE == RegSourceBD ) 
                ) begin
        StallF <= 1'b1; FlushF <= 1'b0;
        StallD <= 1'b1; FlushD <= 1'b0;
        StallE <= 1'b0; FlushE <= 1'b0;
        StallM <= 1'b0; FlushM <= 1'b0;
        StallW <= 1'b0; FlushW <= 1'b0;
    end else if (BranchE) begin
        StallF <= 1'b0; FlushF <= 1'b0;
        StallD <= 1'b0; FlushD <= 1'b1;
        StallE <= 1'b0; FlushE <= 1'b1;
        StallM <= 1'b0; FlushM <= 1'b0;
        StallW <= 1'b0; FlushW <= 1'b0;
    end else if (JumpD) begin
        StallF <= 1'b0; FlushF <= 1'b0;
        StallD <= 1'b0; FlushD <= 1'b1;
        StallE <= 1'b0; FlushE <= 1'b0;
        StallM <= 1'b0; FlushM <= 1'b0;
        StallW <= 1'b0; FlushW <= 1'b0;
    end begin
        StallF <= 1'b0; FlushF <= 1'b0;
        StallD <= 1'b0; FlushD <= 1'b0;
        StallE <= 1'b0; FlushE <= 1'b0;
        StallM <= 1'b0; FlushM <= 1'b0;
        StallW <= 1'b0; FlushW <= 1'b0;
    end
end
//--------------------------------------------------------
always @(*) begin
    if          ( RegReadE[0] && RegWriteM && RegDestinationM != 5'b0 && RegDestinationM == RegSourceAE) begin
        ForwardAE <= 2'b10;
    end else if ( RegReadE[0] && RegWriteW && RegDestinationW != 5'b0 && RegDestinationW == RegSourceAE) begin
        ForwardAE <= 2'b01;
    end else begin
        ForwardAE <= 2'b00;
    end
end
//--------------------------------------------------------
always @(*) begin
    if          ( RegReadE[1] && RegWriteM && RegDestinationM != 5'b0 && RegDestinationM == RegSourceBE) begin
        ForwardBE <= 2'b10;
    end else if ( RegReadE[1] && RegWriteW && RegDestinationW != 5'b0 && RegDestinationW == RegSourceBE) begin
        ForwardBE <= 2'b01;
    end else begin
        ForwardBE <= 2'b00;
    end
end
//--------------------------------------------------------
endmodule
