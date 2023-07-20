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
    wire [6:0]opc;
    wire [2:0]f3;
    wire [6:0]f7;
    
    assign opc=opcode;
    assign f3=funct3;
    assign f7=funct7;
    
    //npc_op
    assign npc_op=opc[6]?opc[3:2]:2'b10;
    
    //rf_wsel
    assign rf_wsel={opc[4],opc[2]};
    
    //ram_we
    assign ram_we=!opc[6]&opc[5]&!opc[4];
    
    //alu_op
    assign alu_op=(opc[6]&opc[5]&!opc[2])?{f3[2:1],1'b1,f3[0]}:(opc[4]?((f3==3'b000)?{f3[2:1],f7[5]&opc[5],f3[0]}:((f3==3'b101)?{f7[5],f3}:{1'b0,f3})):4'b0000); 
    
    //alua_sel
    assign alua_sel=opc[3];
    
    //alub_sel
    assign alub_sel=~((opc[6]&!opc[2])|(opc[5]&opc[4]));
    
    //sext_op
    assign sext_op=(opc[4:2]==3'b001)?(3'b000):{opc[6:5],opc[2]};
    
    //rf_we
    assign rf_we=!opc[5]|opc[4]|opc[2];
    
endmodule
