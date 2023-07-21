`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/14 16:31:51
// Design Name: 
// Module Name: EX
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


module EX(
input clk_i,
input rst_i,
input pause,

input [31:0] aluc_i,
input [31:0]rD2_i,
input [31:0]ext_i,
input [31:0]pc4_i,

input [4:0]wR_i,
input [1:0]rf_wsel_i,
input rf_we_i,

input ram_we_i,

output reg [31:0] aluc_o,
output reg [31:0]rD2_o,
output reg [31:0]ext_o,
output reg [31:0]pc4_o,

output reg[4:0]wR_o,
output reg [1:0]rf_wsel_o,
output reg rf_we_o,

output reg ram_we_o
    );
    
        
always@(posedge clk_i or posedge rst_i)
    begin
    if(rst_i)
    begin
        aluc_o<=0;
        rD2_o<=0;
        ext_o<=0;
        pc4_o<=0;
        
        wR_o<=0;
        rf_wsel_o<=0;
        rf_we_o<=0;
        
        ram_we_o<=0;
    end
    else if(pause)
    begin
        aluc_o<=aluc_o;
        rD2_o<=rD2_o;
        ext_o<=ext_o;
        pc4_o<=pc4_o;
        
        wR_o<=wR_o;
        rf_wsel_o<=rf_wsel_o;
        rf_we_o<=rf_we_o;
        
        ram_we_o<=ram_we_o;
    end
    else
    begin
        aluc_o<=aluc_i;
        rD2_o<=rD2_i;
        ext_o<=ext_i;
        pc4_o<=pc4_i;
        
        wR_o<=wR_i;
        rf_wsel_o<=rf_wsel_i;
        rf_we_o<=rf_we_i;
        
        ram_we_o<=ram_we_i;
    end
    end
endmodule
