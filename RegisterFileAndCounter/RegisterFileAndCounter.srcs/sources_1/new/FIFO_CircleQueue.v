`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 18:24:02
// Design Name: 
// Module Name: FIFO_CircleQueue
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


module FIFO_CircleQueue(
    input clk,
    input rst,
    input en_in,
    input en_out,
    input [3:0] in,
    output full,
    output empty,
    output [3:0] out,
    output [15:0] display
    );
//========================================================================
reg [3:0] tail;
reg [3:0] head;
reg [7:0] valid;
//========================================================================
RegisterFile rf(
    .clk( clk ),
    .rst( rst ),
    .ra0( head ),
    .ra1( position ),
    .wa( tail ),
    .wd( in ),
    .we( en_in_pos && ~full),
    .rd0( out ),
    .rd1( number )
);
//========================================================================
wire en_in_pos, en_out_pos;
reg en_in_stable, en_out_stable;
reg [23:0] en_in_count;
reg [23:0] en_out_count;
always @ (posedge clk or posedge rst)
    begin
        if (rst)
            begin
                en_in_count  <= 20'd0;  en_out_count <= 20'd0;
                en_in_stable <= 1'b0;   en_out_stable <= 1'b0;
            end
        else
            begin
                if(en_in)
                    begin
                        if (en_in_stable) ;
                        else
                            begin
                                en_in_count  <= en_in_count  + 20'd1;
                                if(en_in_count == 24'd1000_0000)  begin en_in_stable = 1'b1; en_in_count <= 20'd0; end
                            end
                    end
                else    begin en_in_count  <= 20'd0; en_in_stable = 1'b0; end
                if(en_out)
                    begin
                        if (en_out_stable) ;
                        else
                            begin
                                en_out_count  <= en_out_count  + 20'd1;
                                if(en_out_count == 24'd1000_0000)  begin en_out_stable = 1'b1; en_out_count <= 20'd0; end
                            end
                    end
                else    begin en_out_count  <= 20'd0; en_out_stable <= 1'b0; end
            end
    end
reg en_in_past1, en_in_past2, en_out_past1, en_out_past2;
always @ (posedge clk or posedge rst)
    begin
        if(rst)
            begin
                en_in_past1 <= 1'b0;    en_in_past2 <= 1'b0;
                en_out_past1 <= 1'b0;   en_out_past2 <= 1'b0;
            end
        else
            begin
                en_in_past1 <= en_in_stable;    en_in_past2 <= en_in_past1;
                en_out_past1 <= en_out_stable;  en_out_past2 <= en_out_past1;
            end
    end
assign en_in_pos  = en_in_past1  & (~en_in_past2);
assign en_out_pos = en_out_past1 & (~en_out_past2);
//========================================================================
assign empty = ( valid == 8'b0000_0000 );
assign full  = ( valid == 8'b1111_1111 );
//========================================================================
always @ (posedge clk or posedge rst)
    begin
        if(rst)
            begin
                head  = 4'b0;
                tail  = 4'b0;
                valid = 8'b0;
            end
        else if(en_in_pos && ~full)
            begin
                valid[ tail ] = 1'b1;
                tail = (tail + 4'd1) % 8;
            end
        else if (en_out_pos && ~empty)
            begin
                valid[ head ] = 1'b0;
                head = (head + 4'd1) % 8;
            end
        else
            begin
                head  = head;
                tail  = tail;
                valid = valid;
            end
    end
//========================================================================
reg clk_slow;
wire [23:0] c3_count;
wire headdot;   assign headdot = position == head;
wire [3:0] number;
reg [2:0] position;
reg c3_rst;
Counter c3(
    .ce(1'b1),
    .pe(1'b0),
    .rst(c3_rst),
    .clk(clk),
    .d(24'd0),
    .q(c3_count)
);
always @ (posedge clk)
    begin
        if (c3_count == 24'd1_00_000)   begin clk_slow <= 1'b1; c3_rst <= 1'b1; end
        else                            begin clk_slow <= 1'b0; c3_rst <= 1'b0; end
    end
DisplayUnit d(
    .validFlag( valid[position] ),
    .number(number),
    .position(position),
    .headdot(headdot),
    .sel(display[ 7:0]),
    .seg(display[15:8])
);
always @ (posedge clk_slow) 
    begin
        position <= position + 3'd1;
    end
//========================================================================
endmodule
