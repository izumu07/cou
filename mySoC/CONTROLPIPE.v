`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/21 07:12:34
// Design Name: 
// Module Name: CONTROLPIPE
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


module CONTROLPIPE(
input clk_i,
input rst_i,
input [31:0]pc_i,
input [31:0]npc_i,
input [4:0]rs1_i,
input [4:0]rs2_i,
input rf_we_ex,
input rf_we_mem,
input rf_we_rb,
input [4:0]wR_ex,
input [4:0]wR_mem,
input [4:0]wR_rb,
input [4:0]opc,
output reg [31:0]npc_o,
output pause,
output reg pause_ex,
output reg pause_mem,
output reg pause_rb
    );
    //Pause
    wire [1:0]cnt;
    wire id_rf1;
    wire id_rf2;
    assign id_rf1=!opc[1]&!(!opc[4]&opc[0]);
    assign id_rf2=({opc[4:2],opc[0]}==4'b0110)||({opc[4:2],opc[0]}==4'b1100);
    
    
    
    assign cnt=((rs1_i==wR_ex)||(rs2_i==wR_ex))&&rf_we_ex?2'b11:(((rs1_i==wR_mem)||(rs2_i==wR_mem))&&rf_we_mem?2'b10:((((rs1_i==wR_rb)&&id_rf1)||((rs2_i==wR_rb)&&id_rf2))&&rf_we_rb?2'b01:2'b00));
    assign pause=(cnt>0)&(!pause_rb);
    
    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            pause_ex<=0;
        else
            pause_ex<=pause;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            pause_mem<=0;
        else
            pause_mem<=pause_ex;
    end

    always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
            pause_rb<=0;
        else
            pause_rb<=pause_mem;
    end
    
    
    
endmodule
