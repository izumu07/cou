`timescale 1ns / 1ps
`include "defines.vh"

module PC(
input [31:0]din,
input clk_i,
input rst_i,
output  reg[31:0] pc
);
always@(posedge clk_i)
begin
if (rst_i)
pc<=0;
else
begin
pc<=din;
end
end
endmodule