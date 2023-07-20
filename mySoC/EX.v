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
input [31:0] aluc_i,
input [31:0]rD2_i,
input [1:0]rf_wsel_i,
input ram_we_i,
output reg [31:0] aluc_o,
output reg [31:0]rD2_o,
output reg [1:0]rf_wsel_o,
output reg ram_we_o
    );
    
        
    always@(posedge clk_i or posedge rst_i)
    begin
    if(rst_i)
    begin
        aluc_o<=0;
        rD2_o<=0;
        rf_wsel_o<=0;
        ram_we_o<=0;
    end
    else
    begin
        aluc_o<=aluc_i;
        rD2_o<=rD2_i;
        rf_wsel_o<=rf_wsel_i;
        ram_we_o<=ram_we_i;
    end
    end
endmodule
