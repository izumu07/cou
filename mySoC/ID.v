`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/14 16:31:32
// Design Name: 
// Module Name: ID
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


module ID(
input clk_i,
input rst_i,

input [31:0]pc_i,
input [1:0]npc_op_i,

input ram_we_i,

input [4:0]wR_i,
input [1:0]rf_wsel_i,
input rf_we_i,

input [3:0]alu_op_i,
input [31:0]alua_i,
input [31:0]alub_i,

input [31:0]ext_i,
input [31:0]rD2_i,

output reg[31:0]pc_o,
output reg[1:0]npc_op_o,

output reg ram_we_o,

output reg[4:0]wR_o,
output reg[1:0] rf_wsel_o,
output reg rf_we_o,

output reg[3:0]alu_op_o,
output reg [31:0]alua_o,
output reg [31:0]alub_o,

output reg [31:0]ext_o,
output reg [31:0]rD2_o
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
    
    always@(posedge clk_i or posedge rst_i)
    begin
    if(rst_i||~temp_rst)
    begin
        pc_o<=0;
        npc_op_o<=0;
        
        ram_we_o<=0;
        
        wR_o<=0;
        rf_wsel_o<=0;
        rf_we_o<=0;
        
        alu_op_o<=0;
        alua_o<=0;
        alub_o<=0;
        
        ext_o<=0;
        rD2_o<=0;
    end
    else
    begin
        pc_o<=pc_i;
        npc_op_o<=npc_op_i;
        
        ram_we_o<=ram_we_i;
        
        wR_o<=wR_i;
        rf_wsel_o<=rf_wsel_i;
        rf_we_o<=rf_we_i;
        
        alu_op_o<=alu_op_i;
        alua_o<=alua_i;
        alub_o<=alub_i;
        
        ext_o<=ext_i;
        rD2_o<=rD2_i;
    end
    end
endmodule
