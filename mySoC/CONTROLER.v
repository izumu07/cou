`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 19:13:09
// Design Name: 
// Module Name: CONTROLER
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


module CONTROLER(
input [6:0]opcode,
input [2:0]funct3,
input [6:0]funct7,
output [1:0]npc_op,
output [1:0]rf_wsel,
output ram_we,
output [3:0]alu_op,
output alua_sel,
output alub_sel,
output [2:0]sext_op,
output rf_we 
    );
    //npc_op
    assign npc_op=opcode[6]?opcode[3:2]:2'b10;
    
    //rf_wsel
    assign rf_wsel={opcode[4],opcode[2]};
    
    //ram_we
    assign ram_we=!funct7[6]&funct7[5]&!funct7[4];
    
    //alu_op
    assign alu_op=(opcode[6]&opcode[5]&!opcode[2])?{funct3[2:1],1'b1,funct3[0]}:(opcode[4]?((funct3==3'b000)?{funct3[2:1],funct7[5]&opcode[5],funct3[0]}:((funct3==3'b101)?{funct7[5],funct3}:{1'b0,funct3})):4'b0000); 
    
    //alua_sel
    assign alua_sel=opcode[3];
    
    //alub_sel
    assign alub_sel=~((opcode[6]&!opcode[2])|(opcode[5]&opcode[4]));
    
    //sext_op
    assign sext_op=(opcode[4:2]==3'b001)?(3'b000):{opcode[6:5],opcode[2]};
    
    //rf_we
    assign rf_we=!opcode[5]|opcode[4]|opcode[2];
    
endmodule
