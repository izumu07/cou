`timescale 1ns / 1ps

`include "defines.vh"

module NPC(
input [31:0]pc,
input [31:0]offset,
input [31:0]C,
input br,
input [1:0]op,
output reg [31:0] npc,
output reg [31:0] pc4
);

always@(*)
begin
    pc4=pc+4;
end

always@(*)
begin
    case(op)
        2'b11:npc=pc+offset;
        2'b01:npc=C;
        2'b10:npc=pc+4;
        2'b00:begin
            if(br)
                npc=pc+offset;
            else
                npc=pc+4;
            end
    endcase
end
endmodule