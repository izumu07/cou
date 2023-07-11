`timescale 1ns / 1ps

`include "defines.vh"

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] op,
    output reg [31:0] C,
    output reg f
  );
  reg [7:0] sel;
  /*
  译码器，待实现
  assign op_add_1=xxx
  assign op_add_2=xxx
  */

  /*
  always@(op)
  begin
  case(op)
  `ALU_OP_ADD: sel<=8'b0000_0001;
  `ALU_OP_SUB: sel<=8'b0000_0010;
  `ALU_OP_AND: sel<=8'b0000_0100;
  `ALU_OP_OR: sel<=8'b0000_1000;
  `ALU_OP_XOR: sel<=8'b0001_0000;
  `ALU_OP_SLL: sel<=8'b0010_0000;
  `ALU_OP_SLR: sel<=8'b0100_0000;
  `ALU_OP_SAR: sel<=8'b1000_0000;
  endcase
  end
  */

  /*
  wire op_out;        //输出选择
  wire op_sub;        
  wire add_o;
  wire sub_o;
  wire and_o;
  wire or_o;
  wire xor_o;
   
  assign add_o=A+B;
  assign sub_o=A-B;
  assign and_o=A&B;
  assign or_o=A|B;
  assign xor_o=A^B;
  */

  reg zero;
  reg lower;

  always@(*)
  begin
    f=0;
    casex(op)
      `ALU_OP_ADD:
        C=A+B;
      `ALU_OP_SUBOP:
      begin
        C=A-B;
        zero=(C==0);
        lower=(A<B);
        f=(zero&!op[3]&!op[0])|(!lower&op[3]&op[0])|(!zero&!op[3]&op[0])|(lower&op[3]&!op[0]);
      end
      `ALU_OP_AND:
        C=A&B;
      `ALU_OP_OR:
        C=A|B;
      `ALU_OP_XOR:
        C=A^B;
      `ALU_OP_SLL:
        C=A<<B[4:0];
      `ALU_OP_SLR:
        C=A>>B[4:0];
      `ALU_OP_SAR:
        //C=A>>>B[4:0];
        //C={A[31],C[30:0]};
        C=( { {31{A[31]}}, 1'b0 } << (~B[4:0]) ) | ( A >> B[4:0] ) ;
      //C= ( {32{A[31]}} << ( 6'd32 - {1'b0, B[4:0]} ) ) | ( A >> B[4:0] ) ;
    endcase
  end

endmodule
