`timescale 1ns / 1ps

`include "defines.vh"

module SEXT(
    input wire [2:0]op,
    input wire [24:0]din,
    output reg [31:0] ext
  );
  always@(*)
  begin
    if(op==3'b00)
        ext={{20{din[24]}},din[24:13]};
    else if(op==3'b010)
        ext={{20{din[24]}},din[24:18],din[4:0]};
    else if(op==3'b110)
        ext={{20{din[24]}},din[0],din[23:18],din[4:1],1'b0};
    else if(op==3'b011)
        ext={din[24:5],12'b0};
    else if(op==3'b111)
        ext={{12{din[24]}},din[12:5],din[13],din[23:14],1'b0};
    else
        ext=ext;
  end

endmodule
