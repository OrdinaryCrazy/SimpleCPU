`timescale 1ns / 1ps
module mips_pipelineCPU (
//--------------------------------------------------------
    input           origin_clk,
    input           rst,
//--------------------------------------------------------
    input           run,
    input   [7:0]   addr,
    output  [31:0]  pc,
    output  [31:0]  mem_data,
    output  [31:0]  reg_data
//--------------------------------------------------------
);
//--------------------------------------------------------
wire clk;
assign clk = origin_clk & run;
//--------------------------------------------------------
wire        StallF;
wire        StallD;
wire        StallE;
wire        StallM;
wire        StallW;

wire        FlushF;
wire        FlushD;
wire        FlushE;
wire        FlushM;
wire        FlushW;

wire        RegDstD;
wire        RegDstE;
wire        RegWriteD;
wire        RegWriteE;
wire        RegWriteM;
wire        RegWriteW;
wire        ALUSrcAD;
wire        ALUSrcAE;
wire        MemReadD;
wire        MemReadE;
wire        MemWriteD;
wire        MemWriteE;
wire        MemWriteM;
wire        MemtoRegD;
wire        MemtoRegE;
wire        MemtoRegM;
wire        MemtoRegW;
wire        JumpD;
wire        Zero;
// wire        BranchE;
reg         BranchE;

// wire [31:0] PC_In;
reg  [31:0] PC_In;
wire [31:0] PCF;
wire [31:0] PCD;
wire [31:0] PCE;
wire [31:0] PCM;
wire [31:0] Instr;
wire [31:0] InstrE;
wire [31:0] InstrM;
wire [31:0] ImmD;
wire [31:0] ImmE;
wire [31:0] RF_RD1;
wire [31:0] RF_RD2;
wire [31:0] RegWriteDataW;
wire [31:0] RegDataAE;
wire [31:0] RegDataBE;
wire [31:0] ForwardDataA;
wire [31:0] ForwardDataB;
wire [31:0] StoreDataM;
wire [31:0] ALUOutE;
wire [31:0] ALUOutM;
wire [31:0] ResultW; 
wire [31:0] OperandA;
wire [31:0] OperandB;
wire [31:0] ReadDataW;

// wire [4:0]  RegWriteAddrW;

wire [4:0]  RegSourceAD;
wire [4:0]  RegSourceBD;
wire [4:0]  RegSourceAE;
wire [4:0]  RegSourceBE;
wire [4:0]  RegDestinationE;
wire [4:0]  RegDestinationM;
wire [4:0]  RegDestinationW;

wire [1:0]  RegReadD;
wire [1:0]  RegReadE;
wire [1:0]  ForwardAE;
wire [1:0]  ForwardBE;
wire [1:0]  ALUSrcBD;
wire [1:0]  ALUSrcBE;
wire [3:0]  ALUCtrlD;
wire [3:0]  ALUCtrlE;

wire [31:0] BrNPC;
wire [31:0] JumpNPC;
// reg  [31:0] PC_In;
//--------------------------------------------------------
assign pc               = PCF;
assign ImmD             = { {16{Instr[15]}}, Instr[15:0] };
assign JumpNPC          = { PCD[31:28], Instr[25:0], 2'b00 };
assign BrNPC            = PCE + 4 + ImmE * 4;
assign RegWriteDataW    = MemtoRegW     ? ReadDataW     : ResultW;
assign OperandA         = ALUSrcAE      ? ForwardDataA  : PCE;
assign OperandB         = ALUSrcBE[1]   ? ImmE          : ForwardDataB;
assign ForwardDataA     = ForwardAE[1]  ? ALUOutM       : ( ForwardAE[0] ? RegWriteDataW : RegDataAE);
assign ForwardDataB     = ForwardBE[1]  ? ALUOutM       : ( ForwardBE[0] ? RegWriteDataW : RegDataBE);
assign RegDestinationE  = RegDstE       ? InstrE[15:11] : InstrE[20:16];

parameter   OP_BEQ      = 6'b000_100;
parameter   OP_BNE      = 6'b000_101;

always @(*) begin
    if          ( InstrE[31:26] == OP_BEQ ) begin
        BranchE = ( OperandA == OperandB );
    end else if ( InstrE[31:26] == OP_BNE ) begin
        BranchE = ( OperandA != OperandB );
    end else begin
        BranchE = 1'b0;
    end
end

always @(*) begin
    /* if (rst) begin
        PC_In = 32'd200;
    end else  */if (BranchE) begin
        PC_In = BrNPC;
    end else if (JumpD) begin
        PC_In = JumpNPC;
    end else begin
        PC_In = PCF + 32'd4;
    end
end
//--------------------------------------------------------
IFSegReg IFSegReg_1 (
    .clk(clk),      /* input               clk,     */
    .rst(rst),      /* input               rst,     */
    .en(~StallF),   /* input               en,      */
    .PC_In(PC_In),  /* input   [31:0]      PC_In,   */
    .PC(PCF)        /* output  reg [31:0]  PC       */
);
//--------------------------------------------------------
IDSegReg IDSegReg_1 (
    .clk(clk),      /* input               clk,     */
    .rst(rst),      /* input               rst,     */
    .clear(FlushD), /* input               clear,   */
    .en(~StallD),   /* input               en,      */
    .Address(PCF),  /* input       [31:0]  Address, */
    .PCF(PCF),      /* input       [31:0]  PCF,     */
    .Inst(Instr),   /* output      [31:0]  Inst,    */
    .PCD(PCD)       /* output  reg [31:0]  PCD      */
);
//--------------------------------------------------------
RegisterFile RegisterFile_1 (
    .clk(clk),                  /* input               clk,         */
    .rst(rst),                  /* input               rst,         */
    .RegWrite(RegWriteW),       /* input               RegWrite,    */
    .ReadAddr1(Instr[25:21]),   /* input       [4:0]   ReadAddr1,   */
    .ReadData1(RF_RD1),         /* output      [31:0]  ReadData1,   */
    .ReadAddr2(Instr[20:16]),   /* input       [4:0]   ReadAddr2,   */
    .ReadData2(RF_RD2),         /* output      [31:0]  ReadData2,   */
    // .WriteAddr(RegWriteAddrW),  /* input       [4:0]   WriteAddr,   */
    .WriteAddr(RegDestinationW),/* input       [4:0]   WriteAddr,   */
    .WriteData(RegWriteDataW),  /* input       [31:0]  WriteData,   */
    .addr(addr[4:0]),           /* input       [4:0]   addr,        */
    .reg_data(reg_data)         /* output      [31:0]  reg_data     */
);
//--------------------------------------------------------
Control Control_1 (
    .clk(clk),              /* input               clk,         */
    .rst(rst),              /* input               rst,         */
    .Op(Instr[31:26]),      /* input       [5:0]   Op,          */
    .Func(Instr[5:0]),      /* input       [5:0]   Func,        */
    .RegDstD(RegDstD),      /* output              RegDstD,     */
    .RegWriteD(RegWriteD),  /* output              RegWriteD,   */
    .ALUSrcAD(ALUSrcAD),    /* output              ALUSrcAD,    */
    .ALUSrcBD(ALUSrcBD),    /* output      [1:0]   ALUSrcBD,    */
    .ALUCtrlD(ALUCtrlD),    /* output  reg [3:0]   ALUCtrlD,    */
    .MemReadD(MemReadD),    /* output              MemReadD,    */
    .MemWriteD(MemWriteD),  /* output              MemWriteD,   */
    .MemtoRegD(MemtoRegD),  /* output              MemtoRegD,   */
    .JumpD(JumpD),          /* output              JumpD        */
    .RegReadD(RegReadD)     /* output  reg [1:0]   RegReadD     */
);
//--------------------------------------------------------
EXSegReg EXSegReg_1 (
    .clk(clk),              /* input               clk,         */
    .en(~StallE),           /* input               en,          */
    .clear(FlushE),         /* input               clear,       */
    .PCD(PCD),              /* input       [31:0]  PCD,         */
    .PCE(PCE),              /* output  reg [31:0]  PCE,         */
    .ImmD(ImmD),            /* input       [31:0]  ImmD,        */
    .ImmE(ImmE),            /* output  reg [31:0]  ImmE,        */
    .InstrD(Instr),         /* input       [31:0]  InstrD,      */
    .InstrE(InstrE),        /* output  reg [31:0]  InstrE,      */
    .RegDataAD(RF_RD1),     /* input       [31:0]  RegDataAD,   */
    .RegDataAE(RegDataAE),  /* output  reg [31:0]  RegDataAE,   */
    .RegDataBD(RF_RD2),     /* input       [31:0]  RegDataBD,   */
    .RegDataBE(RegDataBE),  /* output  reg [31:0]  RegDataBE,   */
    .RegDstD(RegDstD),      /* input               RegDstD,     */
    .RegDstE(RegDstE),      /* output  reg         RegDstE,     */
    .RegWriteD(RegWriteD),  /* input               RegWriteD,   */
    .RegWriteE(RegWriteE),  /* output  reg         RegWriteE,   */
    .ALUSrcAD(ALUSrcAD),    /* input               ALUSrcAD,    */
    .ALUSrcAE(ALUSrcAE),    /* output  reg         ALUSrcAE,    */
    .ALUSrcBD(ALUSrcBD),    /* input       [1:0]   ALUSrcBD,    */
    .ALUSrcBE(ALUSrcBE),    /* output  reg [1:0]   ALUSrcBE,    */
    .MemReadD(MemReadD),    /* input               MemReadD,    */
    .MemReadE(MemReadE),    /* output  reg         MemReadE,    */
    .MemWriteD(MemWriteD),  /* input               MemWriteD,   */
    .MemWriteE(MemWriteE),  /* output  reg         MemWriteE,   */
    .MemtoRegD(MemtoRegD),  /* input               MemtoRegD,   */
    .MemtoRegE(MemtoRegE),  /* output  reg         MemtoRegE    */
    .ALUCtrlD(ALUCtrlD),    /* input       [3:0]   ALUCtrlD,    */
    .ALUCtrlE(ALUCtrlE),    /* output  reg [3:0]   ALUCtrlE     */
    .RegReadD(RegReadD),    /* input       [1:0]   RegReadD,    */
    .RegReadE(RegReadE)     /* output  reg [1:0]   RegReadE     */
);
//--------------------------------------------------------
ALU ALU_1 (
    .SourceA(OperandA), /* input       [31:0]  SourceA, */
    .SourceB(OperandB), /* input       [31:0]  SourceB, */
    .Ctrl(ALUCtrlE),    /* input       [3:0]   Ctrl,    */
    .ALUOut(ALUOutE),   /* output  reg [31:0]  ALUOut,  */
    .Zero(Zero)         /* output              Zero     */
);
//--------------------------------------------------------
MEMSegReg MEMSegReg_1 (
    .clk(clk),                          /* input               clk,             */
    .en(~StallM),                       /* input               en,              */
    .clear(FlushM),                     /* input               clear,           */
    .PCE(PCE),                          /* input       [31:0]  PCE,             */
    .PCM(PCM),                          /* output  reg [31:0]  PCM,             */
    .ForwardDataB(ForwardDataB),        /* input       [31:0]  ForwardDataB,    */
    .StoreDataM(StoreDataM),            /* output  reg [31:0]  StoreDataM,      */
    .ALUOutE(ALUOutE),                  /* input       [31:0]  ALUOutE,         */
    .ALUOutM(ALUOutM),                  /* output  reg [31:0]  ALUOutM,         */
    .InstrE(InstrE),                    /* input       [31:0]  InstrE,          */
    .InstrM(InstrM),                    /* output  reg [31:0]  InstrM,          */
    .RegWriteE(RegWriteE),              /* input               RegWriteE,       */
    .RegWriteM(RegWriteM),              /* output  reg         RegWriteM,       */
    .MemtoRegE(MemtoRegE),              /* input               MemtoRegE,       */
    .MemtoRegM(MemtoRegM),              /* output  reg         MemtoRegM,       */
    .MemWriteE(MemWriteE),              /* input               MemWriteE,       */
    .MemWriteM(MemWriteM),              /* output  reg         MemWriteM        */
    .RegDestinationE(RegDestinationE),  /* input        [4:0]  RegDestinationE, */
    .RegDestinationM(RegDestinationM)   /* output  reg  [4:0]  RegDestinationM  */
);
//--------------------------------------------------------
WBSegReg WBSegReg_1 (
    .clk(clk),                          /* input               clk,             */
    .en(~StallW),                       /* input               en,              */
    .clear(FlushW),                     /* input               clear,           */
    .Address(ALUOutM),                  /* input       [31:0]  Address,         */
    .WriteData(StoreDataM),             /* input       [31:0]  WriteData,       */
    .WriteEn(MemWriteM),                /* input       [31:0]  WriteEn,         */
    .ReadData(ReadDataW),               /* output      [31:0]  ReadData,        */
    .addr(addr),                        /* input       [7:0]   addr,            */
    .mem_data(mem_data),                /* output      [31:0]  mem_data,        */
    .ResultM(ALUOutM),                  /* input       [31:0]  ResultM,         */
    .ResultW(ResultW),                  /* output  reg [31:0]  ResultW,         */
    .RegDestinationM(RegDestinationM),  /* input       [4:0]   RegDestinationM, */
    .RegDestinationW(RegDestinationW),  /* output  reg [4:0]   RegDestinationW, */
    .RegWriteM(RegWriteM),              /* input               RegWriteM,       */
    .RegWriteW(RegWriteW),              /* output  reg         RegWriteW,       */
    .MemtoRegM(MemtoRegM),              /* input               MemtoRegM,       */
    .MemtoRegW(MemtoRegW)               /* output  reg         MemtoRegW        */
);
//--------------------------------------------------------
HarzardUnit HarzardUnit_1 (
    .rst(rst),                          /* input               rst,             */
    .BranchE(BranchE),                  /* input               BranchE,         */
    .JumpD(JumpD),                      /* input               JumpD,           */
    .RegSourceAD(Instr[25:21]),         /* input       [4:0]   RegSourceAD,     */ 
    .RegSourceBD(Instr[20:16]),         /* input       [4:0]   RegSourceBD,     */
    .RegSourceAE(InstrE[25:21]),        /* input       [4:0]   RegSourceAE,     */ 
    .RegSourceBE(InstrE[20:16]),        /* input       [4:0]   RegSourceBE,     */
    .RegDestinationE(RegDestinationE),  /* input       [4:0]   RegDestinationE, */
    .RegDestinationM(RegDestinationM),  /* input       [4:0]   RegDestinationM, */
    .RegDestinationW(RegDestinationW),  /* input       [4:0]   RegDestinationW, */
    .RegReadE(RegReadE),                /* input       [1:0]   RegReadE,        */
    .MemtoRegE(MemtoRegE),              /* input               MemtoRegE,       */
    .RegWriteM(RegWriteM),              /* input               RegWriteM,       */
    .RegWriteW(RegWriteW),              /* input               RegWriteW,       */
    .StallF(StallF),                    /* output  reg         StallF,          */ 
    .StallD(StallD),                    /* output  reg         StallD,          */ 
    .StallE(StallE),                    /* output  reg         StallE,          */ 
    .StallM(StallM),                    /* output  reg         StallM,          */ 
    .StallW(StallW),                    /* output  reg         StallW,          */
    .FlushF(FlushF),                    /* output  reg         FlushF,          */ 
    .FlushD(FlushD),                    /* output  reg         FlushD,          */ 
    .FlushE(FlushE),                    /* output  reg         FlushE,          */ 
    .FlushM(FlushM),                    /* output  reg         FlushM,          */ 
    .FlushW(FlushW),                    /* output  reg         FlushW,          */
    .ForwardAE(ForwardAE),              /* output  reg [1:0]   ForwardAE,       */ 
    .ForwardBE(ForwardBE)               /* output  reg [1:0]   ForwardBE        */
);
//--------------------------------------------------------
endmodule