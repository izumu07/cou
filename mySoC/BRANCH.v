`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/21 13:57:58
// Design Name: 
// Module Name: BRANCH
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


module BRANCH(
input clk_i,
input rst_i,
input [1:0]pred,
output reg flush,
output reg[4:0] flist

    );
    
   wire jump;
   assign jump=pred[1]&!pred[0];


   always @(posedge clk_i or posedge rst_i) begin
        if(rst_i)
        begin
        flush<=0;
        flist<=5'b00000;
        end
        else if(jump)
        begin
            flush<=jump;
            case(flist)
            5'b00000:flist<=5'b01111;
            5'b01111:flist<=5'b00111;
            5'b00111:flist<=5'b00011;
            5'b00011:flist<=5'b00001;
            5'b00001:flist<=5'b00000;
            default:flist<=5'b00000;
            endcase
        end
        else
            flush<=flush;
            flist<=flist;
    end
   
endmodule
