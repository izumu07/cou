`timescale 1ns / 1ps
`include "defines.vh"

module PC(
input [31:0]din,
input clk_i,
input rst_i,
output  reg[31:0] pc
);

reg temp_rst;

always@(posedge clk_i or posedge rst_i )
begin
    if (rst_i)
        temp_rst<=0;
    else if (temp_rst==0)
        temp_rst<=1;
    else
        temp_rst<=1;
end

always@(posedge clk_i or posedge rst_i )
    begin
        if (rst_i)
            pc<=0;
        else if(temp_rst)
            pc<=din;
        else
            pc<=pc;
    end
endmodule