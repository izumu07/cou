// Annotate this macro before synthesis
// `define RUN_TRACE

// TODO: 在此处定义你的宏
// 

// 外设I/O接口电路的端口地�?
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078

`define ALU_OP_ADD   4'b0000
`define ALU_OP_SUB   4'b0010
`define ALU_OP_AND   4'b0111
`define ALU_OP_OR    4'b0110
`define ALU_OP_XOR   4'b0100
`define ALU_OP_SLL   4'b0001
`define ALU_OP_SLR   4'b0101
`define ALU_OP_SAR   4'b1101

`define ALU_OP_BEQ   4'b0010
`define ALU_OP_BNE   4'b0011
`define ALU_OP_BLT   4'b1010
`define ALU_OP_BGE   4'b1011
