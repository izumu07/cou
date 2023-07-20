`timescale 1ns / 1ps

module DIG8(
    input wire clk_i,
    input wire rst_i,
    input wire wen,
    input wire [11:0] addr,
    input wire [31:0] wdata,
    output reg [7:0] dig_en,
    output reg [7:0] dig_data
    );
    reg [3:0] num1 [7:0];
    integer i=0;
always @ (posedge clk_i) begin
if(wen&&addr==12'h000) begin
    num1[0]<=(wdata[0]+wdata[1]*2+wdata[2]*4+wdata[3]*8);
    num1[1]<=(wdata[4]+wdata[5]*2+wdata[6]*4+wdata[7]*8);
    num1[2]<=(wdata[8]+wdata[9]*2+wdata[10]*4+wdata[11]*8);
    num1[3]<=(wdata[12]+wdata[13]*2+wdata[14]*4+wdata[15]*8);
    num1[4]<=(wdata[16]+wdata[17]*2+wdata[18]*4+wdata[19]*8);
    num1[5]<=(wdata[20]+wdata[21]*2+wdata[22]*4+wdata[23]*8);
    num1[6]<=(wdata[24]+wdata[25]*2+wdata[26]*4+wdata[27]*8);
    num1[7]<=(wdata[28]+wdata[29]*2+wdata[30]*4+wdata[31]*8);
    end
    else begin
    num1[0]<=num1[0];
    num1[1]<=num1[1];
    num1[2]<=num1[2];
    num1[3]<=num1[3];
    num1[4]<=num1[4];
    num1[5]<=num1[5];
    num1[6]<=num1[6];
    num1[7]<=num1[7];
    end
end
always @ (*) begin
    for(i=0;i<8;i=i+1) begin
    if(dig_en[i]==0) begin
    case(num1[i]) 
            4'd0:dig_data = 8'b00000011;
            4'd1:dig_data = 8'b10011111;
            4'd2:dig_data = 8'b00100101;
            4'd3:dig_data = 8'b00001101;
            4'd4:dig_data = 8'b10011001;
            4'd5:dig_data = 8'b01001001;
            4'd6:dig_data = 8'b01000001;
            4'd7:dig_data = 8'b00011111;
            4'd8:dig_data = 8'b00000001;
            4'd9:dig_data = 8'b00011001;
            4'd10:dig_data = 8'b00010001;
            4'd11:dig_data = 8'b11000001;
            4'd12:dig_data = 8'b11100101;
            4'd13:dig_data = 8'b10000101;
            4'd14:dig_data = 8'b01100001;
            4'd15:dig_data = 8'b01110001;
    default dig_data=8'b11111111;
    endcase
    end
    end
end
reg [20:0] cnt; 
reg cnt_inc;
wire cnt_end=(cnt_inc) & (cnt==21'h2000);//ea60
always@(posedge clk_i or posedge rst_i)begin
        if(rst_i)           cnt_inc<=1'b1;
        else if(cnt_end)  cnt_inc<=1'b0;
        else if(1)    cnt_inc<=1'b1;
        else              cnt_inc<=cnt_inc;
    end
    always@(posedge clk_i or posedge rst_i)begin
        if(rst_i)           cnt<=20'h0;
        else if(cnt_end)  cnt<=20'h0;
        else if(cnt_inc)  cnt<=cnt+20'h1; 
    end
    always@(posedge clk_i or posedge rst_i)begin
        if(rst_i)           dig_en<=8'b11111110;
        else if(cnt_end)  dig_en<={dig_en[6:0],dig_en[7]};
        else              dig_en<=dig_en;         
    end
endmodule
