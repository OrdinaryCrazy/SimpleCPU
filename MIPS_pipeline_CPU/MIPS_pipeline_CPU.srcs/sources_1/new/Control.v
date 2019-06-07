`timescale 1ns / 1ps
module Control (
//----------------------------------------------------------------------------
    input               clk,
    input               rst,
//----------------------------------------------------------------------------
    input       [5:0]   Op,             // 六位操作码
    input       [5:0]   Func,
    output              RegDstD,        // 选择 rd(1) 或 rt(0) 作为写操作的目的寄存器
    output              RegWriteD,      // 寄存器写信号
    output              ALUSrcAD,       // 1 - 寄存器，0 - PC
    output      [1:0]   ALUSrcBD,       // 00 - 寄存器，01 - 4，10 - 32位立即数符号扩展，11 - 32位立即数符号扩展左移两位
    output  reg [3:0]   ALUCtrlD,       // ALU控制信号
    output              MemReadD,       // 读内存
    output              MemWriteD,      // 写内存
    output              MemtoRegD,      // 内存到寄存器
    output              JumpD,          //
    output  reg [1:0]   RegReadD
//----------------------------------------------------------------------------
    );
//----------------------------------------------------------------------------
parameter   OP_J        = 6'b000_010;
parameter   OP_R_TYPE   = 6'b000_000;

parameter   OP_ADDI     = 6'b001_000;
parameter   OP_SLTI     = 6'b001_010;
parameter   OP_ANDI     = 6'b001_100;
parameter   OP_ORI      = 6'b001_101;
parameter   OP_XORI     = 6'b001_110;

parameter   OP_BEQ      = 6'b000_100;
parameter   OP_BNE      = 6'b000_101;
parameter   OP_LW       = 6'b100_011;
parameter   OP_SW       = 6'b101_011;

assign RegDstD      = ( Op == OP_R_TYPE );
assign RegWriteD    = ( Op == OP_R_TYPE ) | ( Op[5:3] == 3'b001 ) | ( Op == OP_LW );
assign ALUSrcAD     = 1'b1;                 // 这里先设为0
assign ALUSrcBD     = ( Op == OP_R_TYPE || Op == OP_BEQ || Op == OP_BNE ) ? 2'b00 : 2'b10;
assign MemtoRegD    = ( Op == OP_LW     );
assign MemReadD     = ( Op == OP_LW     );
assign MemWriteD    = ( Op == OP_SW     );
assign JumpD        = ( Op == OP_J      );

always @(*) begin
    RegReadD[0] <=      ( Op == OP_R_TYPE ) || ( Op == OP_LW ) || ( Op == OP_BEQ )
                    ||  ( Op == OP_BNE    ) || ( Op == OP_SW ) || ( Op[5:3] == 3'b001 );
    RegReadD[1] <=      ( Op == OP_R_TYPE ) ||/*(Op == OP_LW)||*/ ( Op == OP_BEQ )
                    ||  ( Op == OP_BNE    ) || ( Op == OP_SW );
end

// always @ (posedge clk) begin
always @ (*) begin
    if ( Op == OP_BEQ || Op == OP_BNE ) begin
                            ALUCtrlD = `ALU_SUB;
    end else if ( Op == OP_LW || Op == OP_SW ) begin
                            ALUCtrlD = `ALU_ADD;
    end else if ( Op == OP_R_TYPE ) begin
        case (Func)
            `FUNC_ADD   :   ALUCtrlD = `ALU_ADD;
            `FUNC_SUB   :   ALUCtrlD = `ALU_SUB;
            `FUNC_SLT   :   ALUCtrlD = `ALU_LT;
            `FUNC_AND   :   ALUCtrlD = `ALU_AND;
            `FUNC_OR    :   ALUCtrlD = `ALU_OR;
            `FUNC_XOR   :   ALUCtrlD = `ALU_XOR;
            `FUNC_NOR   :   ALUCtrlD = `ALU_NOR;
            default     :   ALUCtrlD = 4'b1111;
        endcase
    end else if ( Op[5:3] == 3'b001 ) begin
        case (Op)
            `FUNC_ADDI  :   ALUCtrlD = `ALU_ADD;
            `FUNC_SLTI  :   ALUCtrlD = `ALU_LT;
            `FUNC_ANDI  :   ALUCtrlD = `ALU_AND;
            `FUNC_ORI   :   ALUCtrlD = `ALU_OR;
            `FUNC_XORI  :   ALUCtrlD = `ALU_XOR;
            default     :   ALUCtrlD = 4'b1111;
        endcase
    end else begin
                            ALUCtrlD = 4'b1111;
    end
end

//-----------------------------------------------------------------------
endmodule