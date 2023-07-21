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
input pause,
input flush,

input [31:0]inst_i,
input [31:0]pc_i,

output reg [31:0]inst_o,
output reg [31:0]pc_o
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
        inst_o<=0;
        pc_o<=0;
    end
    else if(pause)
    begin
        inst_o<=inst_o;
        pc_o<=pc_o;
    end
     else if(flush)
    begin
        inst_o<=0;
        pc_o<=0;
    end
    else
    begin
        inst_o<=inst_i;
        pc_o<=pc_i;
    end
    end
endmodule
