`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/14 19:50:50
// Design Name: 
// Module Name: mipsCPU
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


module mipsCPU(
//----------------------------------------
    input               origin_clk,
    input               rst,
//----------------------------------------
    input               run,
    input       [7:0]   addr,
    output  reg [31:0]  pc,
    output      [31:0]  mem_data,
    output      [31:0]  reg_data
//----------------------------------------
    );
//----------------------------------------
wire clk;
assign clk = origin_clk & run;
//----------------------------------------
reg [31:0]  InstructionRegister;
reg [31:0]  MemoryDataRegister;
reg [31:0]  ALUOut;
reg [31:0]  A;
reg [31:0]  B;
//===================================
wire        Zero;
wire        PCWriteCond;
wire        PCWrite;
wire [31:0] ALU_result;
wire [31:0] Jump_address;
wire [31:0] Address;
wire        IorD;
wire        MemRead;
wire        MemWrite;
wire [31:0] MemData;
wire [31:0] RegtoA;
wire [31:0] RegtoB;
wire        MemtoReg;
wire        IRWrite;
wire        RegDst;
wire [1:0]  ALUSrcB;
wire        ALUSrcA;
wire [31:0] SourceB;
wire [31:0] SourceA;
wire [4:0]  RegWriteAddr;
wire [31:0] RegWriteData;
wire [3:0]  Ctrl;
wire [1:0]  ALUOp;
wire [1:0]  PCSource;
wire        I_TYPE;

assign I_TYPE = ( InstructionRegister[31:29] == 3'b001 );

assign Jump_address = {pc[31:28], InstructionRegister[25:0], 2'b00};
//===================================
always @(posedge clk or posedge rst)
    begin
        if(rst)
            pc  <= 32'd44;
        else
            begin
                if( PCWrite | ( Zero & PCWriteCond ) | ( ~Zero & PCWriteCondBNE ) )
                    begin
                        case (PCSource)
                            2'b00   : pc <= ALU_result;
                            2'b01   : pc <= ALUOut;
                            2'b10   : pc <= Jump_address;
                            default : pc <= ALU_result;
                        endcase
                    end
            end
    end
//===================================
assign Address      = IorD      ? ALUOut                        : pc;
//===================================
assign RegWriteData = MemtoReg  ? MemoryDataRegister            : ALUOut;
//===================================
assign RegWriteAddr = RegDst    ? InstructionRegister[15:11]    : InstructionRegister[20:16];
//===================================
assign SourceB      =   ALUSrcB[1]      ?       
                        ( ALUSrcB[0]    ? { {14{InstructionRegister[15]}}, InstructionRegister[15:0], 2'b00 } 
                                        : { {16{InstructionRegister[15]}}, InstructionRegister[15:0] }
                        )
                                        :   
                        ( ALUSrcB[0]    ? 32'd4 
                                        : B 
                        );
//===================================
assign SourceA      = ALUSrcA ? A   :   pc;
//===================================
always @(posedge clk)
    begin
        MemoryDataRegister  <= MemData;
        A <= RegtoA;
        B <= RegtoB;
        ALUOut <= ALU_result;
        if(IRWrite) InstructionRegister <= MemData;
        else        InstructionRegister <= InstructionRegister;
    end
//===================================
Control ctrl(
    .clk(clk),
    .rst(rst),
    .Op(InstructionRegister[31:26]),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ALUOp(ALUOp),
    .PCSource(PCSource),
    .PCWriteCond(PCWriteCond),
    .PCWriteCondBNE(PCWriteCondBNE),
    .PCWrite(PCWrite),
    .IorD(IorD),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .IRWrite(IRWrite)
);
Memory mem(
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Address(Address),
    .WriteData(B),
    .MemData(MemData),
    .addr(addr),
    .mem_data(mem_data)
);
ALUControl alu_ctrl(
    .ALUOp(ALUOp),
    .Func( I_TYPE ? InstructionRegister[31:26] : InstructionRegister[5:0] ),
    .Ctrl(Ctrl)
);
ALU alu(
    .SourceA(SourceA),
    .SourceB(SourceB),
    .Ctrl(Ctrl),
    .ALUOut(ALU_result),
    .Zero(Zero)
);
RegisterFile RF(
    .clk(clk),
    .rst(rst),
    .RegWrite(RegWrite),
    .ReadAddr1(InstructionRegister[25:21]),
    .ReadData1(RegtoA),
    .ReadAddr2(InstructionRegister[20:16]),
    .ReadData2(RegtoB),
    .WriteAddr(RegWriteAddr),
    .WriteData(RegWriteData),
    .addr(addr[4:0]),
    .reg_data(reg_data)
);
//----------------------------------------
endmodule