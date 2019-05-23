`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/14 19:55:29
// Design Name: 
// Module Name: Control
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


module Control(
//----------------------------------------------------------------------------
    input               clk,
    input               rst,
//----------------------------------------------------------------------------
    input       [5:0]   Op,             // 六位操作码
    output  reg         RegDst,         // 选择 rt(1) 或 rd(0) 作为写操作的目的寄存器
    output  reg         RegWrite,       // 寄存器写信号
    output  reg         ALUSrcA,        // 1 - 寄存器，0 - PC
    output  reg [1:0]   ALUSrcB,        // 00 - 寄存器，01 - 4，10 - 32位立即数符号扩展，11 - 32位立即数符号扩展左移两位
    output  reg [1:0]   ALUOp,          // ALU控制信号
    output  reg [1:0]   PCSource,       // 00 - PC + 4，01 - Branch，10 - Jump
    output  reg         PCWriteCond,    // Branch
    output  reg         PCWriteCondBNE, // Branch BNE
    output  reg         PCWrite,        // Jump
    output  reg         IorD,           // 指令读取还是数据读写
    output  reg         MemRead,        // 读内存
    output  reg         MemWrite,       // 写内存
    output  reg         MemtoReg,       // 内存到寄存器
    output  reg         IRWrite         // 写IR
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

parameter   STATE_IF            = 0;
parameter   STATE_ID            = 1;
parameter   STATE_MemAddrGet    = 2;
parameter   STATE_LW_MemAccess  = 3;
parameter   STATE_WB            = 4;
parameter   STATE_SW_MemAccess  = 5;
parameter   STATE_EXE           = 6;
parameter   STATE_R_TYPE_END    = 7;
parameter   STATE_BRANCH        = 8;
parameter   STATE_JUMP          = 9;
parameter   STATE_I_EXE         = 10;
parameter   STATE_START         = 11;
parameter   STATE_I_TYPE_END    = 12;

reg[3:0]    state;
reg[3:0]    next_state;

//always @(posedge clk or posedge rst)
always @(*)
    begin
        if(rst)
            begin
                IorD            <= 1'b0;
                IRWrite         <= 1'b1;
                RegWrite        <= 1'b0;
                MemWrite        <= 1'b0;
                PCWriteCond     <= 1'b0;
                PCWriteCondBNE  <= 1'b0;
                MemRead         <= 1'b1;
                ALUSrcA         <= 1'b0; 
                PCWrite         <= 1'b0;
                ALUOp           <= 2'b00;
                ALUSrcB         <= 2'b01;
                PCSource        <= 2'b00;
            end
        else
            begin
                PCWriteCond     <= (Op == OP_BEQ) & (next_state == STATE_BRANCH);
                PCWriteCondBNE  <= (Op == OP_BNE) & (next_state == STATE_BRANCH);
                
                case (next_state)
                //----------------------------------------------
                    STATE_IF            :
                        begin
                            RegWrite    <= 1'b0;
                            MemWrite    <= 1'b0;                        
                            MemRead     <= 1'b1;
                            ALUSrcA     <= 1'b0;
                            IorD        <= 1'b0;
                            IRWrite     <= 1'b1;
                            PCWrite     <= 1'b1;
                            ALUOp       <= 2'b00;
                            ALUSrcB     <= 2'b01;
                            PCSource    <= 2'b00;
                        end
                //----------------------------------------------
                    STATE_ID            :
                        begin
                            RegWrite    <= 1'b0;
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            ALUSrcA     <= 1'b0;
                            ALUSrcB     <= 2'b11;
                            ALUOp       <= 2'b00;
                        end
                //----------------------------------------------
                    STATE_MemAddrGet    :
                        begin
                            RegWrite    <= 1'b0;
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            ALUSrcA     <= 1'b1;
                            ALUSrcB     <= 2'b10;
                            ALUOp       <= 2'b00;
                        end
                //----------------------------------------------
                    STATE_LW_MemAccess  :
                        begin
                            RegWrite    <= 1'b0;
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            MemRead     <= 1'b1;
                            IorD        <= 1'b1;
                        end
                //----------------------------------------------
                    STATE_WB            :
                        begin
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            RegDst      <= 1'b0;
                            RegWrite    <= 1'b1;
                            MemtoReg    <= 1'b1;
                        end
                //----------------------------------------------
                    STATE_SW_MemAccess  :
                        begin
                            RegWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            MemWrite    <= 1'b1;
                            IorD        <= 1'b1;
                        end
                //----------------------------------------------
                    STATE_EXE           :
                        begin
                            RegWrite    <= 1'b0;
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            ALUSrcA     <= 1'b1;
                            ALUSrcB     <= 2'b00;
                            ALUOp       <= 2'b10;
                        end
                //----------------------------------------------
                    STATE_R_TYPE_END    :
                        begin
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            RegDst      <= 1'b1;
                            RegWrite    <= 1'b1;
                            MemtoReg    <= 1'b0;
                        end
                //----------------------------------------------
                    STATE_BRANCH        :
                        begin
                            RegWrite    <= 1'b0;
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            ALUSrcA     <= 1'b1;
                            ALUSrcB     <= 2'b00;
                            ALUOp       <= 2'b01;
                            PCSource    <= 2'b01;
                        end
                //----------------------------------------------
                    STATE_JUMP          :
                        begin
                            RegWrite    <= 1'b0;
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b1;
                            PCSource    <= 2'b10;
                        end
                //----------------------------------------------
                    STATE_I_EXE         :
                        begin
                            RegWrite    <= 1'b0;
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            ALUSrcA     <= 1'b1;
                            ALUSrcB     <= 2'b10;
                            ALUOp       <= 2'b10;
                        end
                    STATE_I_TYPE_END    :
                        begin
                            MemWrite    <= 1'b0;
                            IRWrite     <= 1'b0;
                            PCWrite     <= 1'b0;
                            RegDst      <= 1'b0;
                            RegWrite    <= 1'b1;
                            MemtoReg    <= 1'b0;
                        end
                //----------------------------------------------

                endcase
            end
    end
always @(state)
    begin
        case (state)
        //-----------------------------------------------------------------------
            STATE_START         :   next_state <= STATE_IF;
        //-----------------------------------------------------------------------
            STATE_IF            :   next_state <= STATE_ID;
        //-----------------------------------------------------------------------
            STATE_ID            :
                begin
                    case (Op)
                        OP_LW       : next_state <= STATE_MemAddrGet;
                        OP_SW       : next_state <= STATE_MemAddrGet;
                        OP_R_TYPE   : next_state <= STATE_EXE;
                        OP_BEQ      : next_state <= STATE_BRANCH;
                        OP_BNE      : next_state <= STATE_BRANCH;
                        OP_J        : next_state <= STATE_JUMP;
                        OP_ADDI     : next_state <= STATE_I_EXE;
                        OP_ANDI     : next_state <= STATE_I_EXE;
                        OP_ORI      : next_state <= STATE_I_EXE;
                        OP_SLTI     : next_state <= STATE_I_EXE;
                        OP_XORI     : next_state <= STATE_I_EXE;
                        default     : next_state <= STATE_IF;
                    endcase
                end
        //-----------------------------------------------------------------------
            STATE_MemAddrGet    :
                begin
                    case (Op)
                        OP_LW       : next_state <= STATE_LW_MemAccess;
                        OP_SW       : next_state <= STATE_SW_MemAccess;
                        default     : next_state <= STATE_IF;
                    endcase
                end
        //-----------------------------------------------------------------------
            STATE_LW_MemAccess  :   next_state <= STATE_WB;
        //-----------------------------------------------------------------------
            STATE_WB            :   next_state <= STATE_IF;
        //-----------------------------------------------------------------------
            STATE_SW_MemAccess  :   next_state <= STATE_IF;
        //-----------------------------------------------------------------------
            STATE_EXE           :   next_state <= STATE_R_TYPE_END;
        //-----------------------------------------------------------------------
            STATE_R_TYPE_END    :   next_state <= STATE_IF;
        //-----------------------------------------------------------------------
            STATE_BRANCH        :   next_state <= STATE_IF;
        //-----------------------------------------------------------------------
            STATE_JUMP          :   next_state <= STATE_IF;
        //-----------------------------------------------------------------------
            STATE_I_EXE         :   next_state <= STATE_I_TYPE_END;
        //-----------------------------------------------------------------------
            STATE_I_TYPE_END    :   next_state <= STATE_IF;
        //-----------------------------------------------------------------------
            default             :   next_state <= STATE_IF;
        //-----------------------------------------------------------------------
        endcase
    end
//-----------------------------------------------------------------------
always @(posedge clk or posedge rst)
    begin
        if(rst) state = STATE_START;
        else    state = next_state;
    end
//-----------------------------------------------------------------------
endmodule