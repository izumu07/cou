`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/14 16:32:07
// Design Name: 
// Module Name: MEM
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


module MEM(
input clk_i,
input rst_i,
input [31:0]rdo_i,
input [1:0]rf_wsel_mem,
output reg[31:0]rdo_o,
output reg[1:0]rf_wsel_rb
    );
    
        
    always@(posedge clk_i or posedge rst_i)
    begin
    if(rst_i)
    begin
        rdo_o<=0;
        rf_wsel_rb<=0;
    end
    else
    begin
        rdo_o<=rdo_i;
        rf_wsel_rb<=rf_wsel_mem;
    end
    end
endmodule
