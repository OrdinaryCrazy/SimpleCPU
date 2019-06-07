`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/14 21:02:46
// Design Name: 
// Module Name: DDU
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


module DDU(
//------------------------------------------------------------------------------
    input           clk,
    input           rst,
//------------------------------------------------------------------------------
    input           cont,
    input           step,
    input           mem,
    input           inc,
    input           dec,
    output  [15:0]  led,
    output  [15:0]  seg
//------------------------------------------------------------------------------
    );
//------------------------------------------------------------------------------
wire            run;
reg     [7:0]   addr;
wire    [31:0]  pc;
assign  led = { addr[7:0], pc[7:0] };

wire            step_pos;
reg             step_past1, step_past2, step_stable;
reg     [23:0]  step_count;

wire            inc_pos;
reg             inc_past1, inc_past2, inc_stable;
reg     [23:0]  inc_count;

wire            dec_pos;
reg             dec_past1, dec_past2, dec_stable;
reg     [23:0]  dec_count;

wire    [31:0]  mem_data;
wire    [31:0]  reg_data;
//******************************************************
mips_pipelineCPU cpu(
//----------------------------------------------
    /* input                */ .origin_clk(clk),
    /* input                */ .rst(rst),
//----------------------------------------------
    /* input                */ .run(run),
    /* input       [7:0]    */ .addr(addr),
    /* output  reg [31:0]   */ .pc(pc),
    /* output      [31:0]   */ .mem_data(mem_data),
    /* output      [31:0]   */ .reg_data(reg_data)
//----------------------------------------------
    );
//******************************************************
always @ (posedge clk or posedge rst)
    begin
        if (rst)    
            begin   
                step_count  <= 24'd0;   step_stable <= 1'b0;
                inc_count   <= 24'd0;   inc_stable  <= 1'b0;
                dec_count   <= 24'd0;   dec_stable  <= 1'b0;    
            end
        else
            begin
            //--------------------------------------------------------------------
                if(step)
                    begin
                        if (step_stable) ;
                        else
                            begin
                                step_count <= step_count + 24'd1;
                                if(step_count == 24'd1000_0000)  
                                    begin 
                                        step_stable <= 1'b1; 
                                        step_count  <= 24'd0; 
                                    end
                            end
                    end
                else    begin step_count  <= 24'd0; step_stable = 1'b0; end
            //--------------------------------------------------------------------
                if(inc)
                    begin
                        if (inc_stable) ;
                        else
                            begin
                                inc_count <= inc_count + 24'd1;
                                if(inc_count == 24'd1000_0000)  
                                    begin 
                                        inc_stable <= 1'b1; 
                                        inc_count  <= 24'd0; 
                                    end
                            end 
                    end
                else    begin inc_count  <= 24'd0; inc_stable = 1'b0; end
            //--------------------------------------------------------------------
                if(dec)
                    begin
                        if (dec_stable) ;
                        else
                            begin
                                dec_count <= dec_count + 24'd1;
                                if(dec_count == 24'd1000_0000)  
                                    begin 
                                        dec_stable <= 1'b1; 
                                        dec_count  <= 24'd0; 
                                    end
                            end
                    end
                else    begin dec_count  <= 24'd0; dec_stable = 1'b0; end
            //--------------------------------------------------------------------
            end
    end
//------------------------------------------------------------------------------
always @ (posedge clk or posedge rst)
    begin
        if(rst) 
            begin   
                step_past1 <= 1'b0;         step_past2 <= 1'b0;         
                inc_past1  <= 1'b0;          inc_past2 <= 1'b0;         
                dec_past1  <= 1'b0;          dec_past2 <= 1'b0;         
            end
        else    
            begin   
                step_past1 <= step_stable;  step_past2 <= step_past1;   
                inc_past1  <= inc_stable;   inc_past2  <= inc_past1;   
                dec_past1  <= dec_stable;   dec_past2  <= dec_past1;   
            end
    end
//------------------------------------------------------------------------------
assign step_pos = step_past1 & (~step_past2);
assign inc_pos  = inc_past1  & (~inc_past2);
assign dec_pos  = dec_past1  & (~dec_past2);
assign run = cont | step_pos;
//------------------------------------------------------------------------------
always @ (posedge clk) 
    begin
        if(rst)
            addr <= 0;
        else if(inc_pos)
            addr <= addr + 1;
        else if(dec_pos)
            addr <= addr - 1;
    end 
//------------------------------------------------------------------------------
reg             clk_slow;
reg     [23:0]  clk_count;
reg     [3:0]   number;
reg     [2:0]   position;
//------------------------------------------------------------------------------
always @ (posedge clk)
    begin
        if (clk_count == 24'd1_00_000)  begin clk_slow <= 1'b1; clk_count <= 24'b0;             end
        else                            begin clk_slow <= 1'b0; clk_count <= clk_count + 24'd1; end
    end
//------------------------------------------------------------------------------
DisplayUnit dpu(
//----------------------------------------------
    /* input       [3:0]  */ .number(number),
    /* input       [2:0]  */ .position(position),
//----------------------------------------------
    /* output  reg [7:0]  */ .sel(seg[7:0]),
    /* output  reg [7:0]  */ .seg(seg[15:8])
//----------------------------------------------
    );
//------------------------------------------------------------------------------
always @ (posedge clk_slow) 
    begin
        position <= position + 3'd1;
    end
//------------------------------------------------------------------------------
always @ (*)
    begin
        if(mem)
            case(position)
                3'b000: number = mem_data[3:0];
                3'b001: number = mem_data[7:4];
                3'b010: number = mem_data[11:8];
                3'b011: number = mem_data[15:12];
                3'b100: number = mem_data[19:16];
                3'b101: number = mem_data[23:20];
                3'b110: number = mem_data[27:24];
                3'b111: number = mem_data[31:28];
            endcase
        else
            case(position)
                3'b000: number = reg_data[3:0];
                3'b001: number = reg_data[7:4];
                3'b010: number = reg_data[11:8];
                3'b011: number = reg_data[15:12];
                3'b100: number = reg_data[19:16];
                3'b101: number = reg_data[23:20];
                3'b110: number = reg_data[27:24];
                3'b111: number = reg_data[31:28];
            endcase
    end
//------------------------------------------------------------------------------
endmodule
