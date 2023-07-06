`timescale 1ns / 1ps

`include "defines.vh"

module SEXT(
input [2:0]op,
input [24:0]din,
output reg [31:0] ext
);
always@(*)
begin
ext=32'b0;
case(op)
3'b000:ext[11:0]=din[24:13];
3'b001:begin
ext[11:5]=din[24:18];
ext[4:0]=din[4:0];
end
3'b010:begin
ext[11]=din[24];
ext[10]=din[0];
ext[9:4]=din[23:18];
ext[3:0]=din[4:1];
end
3'b011:ext[31:12]=din[24:5];
3'b100:begin
ext[19]=din[24];
ext[18:11]=din[12:5];
ext[10]=din[13];
ext[9:0]=din[23:14];
end
default:ext=ext;
endcase
end
endmodule