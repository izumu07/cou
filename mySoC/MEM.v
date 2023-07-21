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
input pause,

input [31:0]wD_i,
input [4:0]wR_i,
input rf_we_i,
output reg[31:0]wD_o,
output reg[4:0]wR_o,
output reg rf_we_o
    );
    
        
    always@(posedge clk_i or posedge rst_i)
    begin
    if(rst_i)
    begin
        wD_o<=0;
        wR_o<=0;
        rf_we_o<=0;
    end
    else if(pause)
    begin
        wD_o<=wD_o;
        wR_o<=wR_o;
        rf_we_o<=rf_we_o;
    end
    else
    begin
        wD_o<=wD_i;
        wR_o<=wR_i;
        rf_we_o<=rf_we_i;
    end
    end
endmodule
