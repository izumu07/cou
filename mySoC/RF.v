`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/07/03 20:08:09
// Design Name:
// Module Name: RF
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
`include "defines.vh"


module RF(
    input [4:0]rR1,
    input [4:0]rR2,
    input [4:0]wR,
    input [31:0]wD,
    input clk_i,
    input rst_i,
    input op,
    output reg [31:0]rD1,
    output reg [31:0]rD2
  );
  reg [31:0]rfs[31:1];
  integer k;
  always@(*)
  begin
    if(rR1==32'b0)
      rD1=32'b0;
    else
      rD1=rfs[rR1];
    if(rR2==32'b0)
      rD2=32'b0;
    else
      rD2=rfs[rR2];
  end

  always@(posedge clk_i  or posedge rst_i)
  begin
    if(rst_i)
      for (k=1;k<32;k=k+1)
        rfs[k]<=32'b0;
    else if(wR!=32'h0)
    begin
      if(op)
        rfs[wR]<=wD;
    end
  end

endmodule
