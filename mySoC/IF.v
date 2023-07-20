`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/14 16:30:26
// Design Name: 
// Module Name: IF
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


module IF(
input clk_i,
input rst_i,
input [31:0]pc4_i,
input [31:0]inst_i,
input [31:0]pc_i,
output reg [31:0]pc4_o,
output reg [31:0]inst_o,
output reg [31:0]pc_o
    );
    
    always@(posedge clk_i or posedge rst_i)
    begin
    if(rst_i)
    begin
        pc4_o<=0;
        inst_o<=0;
        pc_o<=0;
        npc_o<=0;
    end
    else
    begin
        pc4_o<=pc4_i;
        inst_o<=inst_i;
        pc_o<=pc_i;
        npc_o<=npc_i;
    end
    end
endmodule
