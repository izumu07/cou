`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 15:03:46
// Design Name: 
// Module Name: MUX4
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


module MUX4(
input [31:0]i1,
input [31:0]i2,
input [31:0]i3,
input [31:0]i4,
input [1:0]op,
output [31:0]o
    );
assign o=op[0]?(op[1]?i4:i2):(op[1]?i3:i1);
endmodule
