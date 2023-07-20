`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/19 21:47:06
// Design Name: 
// Module Name: LED
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


module LED(
    input  clk_i,
    input rst_i,
    input wen,
    input [11:0] addr,
    input [31:0] wdata,
    output reg [23:0] led
    );
    always @ (posedge clk_i or posedge rst_i) begin
        if(rst_i) 
            led<=0;
        else if(wen&&addr=='h060) 
            led<={wdata[23:0]};
        else 
            led<=led;
    end
endmodule
