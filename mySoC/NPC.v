`timescale 1ns / 1ps

`include "defines.vh"

module NPC(
input [31:0]pc,
input [31:0]offset,
input br,
input [1:0]op,
output reg npc,
output reg pc4
);

always@(*)
begin
    pc4=pc+'d4;
    case(op)
        2'b00:npc=pc4;
        2'b01:npc=pc+offset;
        2'b10:begin
            if(br)
                npc=pc+offset;
            else
                npc=pc4;
            end
        2'b11:npc=npc;
        default:npc=npc;
    endcase
end
endmodule