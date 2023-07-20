`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [13:0]  inst_addr,
    input  wire [31:0]  inst,

    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
  );

  // TODO: 完成你自己的单周期CPU设计
  //
  wire [31:0]npc2pc;
  wire [31:0]rD2;
  wire [31:0]pc4;
  wire [31:0]pc;
  wire [31:0]wD;
  wire [31:0]rD1;
  wire [31:0]ext;
  wire ram_we;
  wire [31:0]rdo;
  assign rdo=Bus_rdata;

  wire [31:0] A;
  wire [31:0] B;
  wire [31:0] C;
  wire f;
  assign Bus_addr=C;


  wire [1:0]npc_op;
  wire [2:0]sext_op;
  wire rf_we;
  wire [3:0] alu_op;
  wire [1:0]rf_wsel;
  wire alua_sel;
  wire alub_sel;


  wire [31:0]pc4_id;
  wire [31:0]inst_id;
  wire [31:0]pc_id;


wire [1:0]rf_wsel_ex;
wire [1:0]npc_op_ex;
wire ram_we_ex;
wire[3:0] alu_op_ex;
wire[31:0] A_ex;
wire [31:0]B_ex;
wire[31:0] ext_ex;
wire  [31:0]rD1_ex;
wire [31:0]rD2_ex;

  PC U_PC(
       .din(npc2pc),
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .pc(pc)
     );

  NPC U_NPC(
        .pc(pc),
        .offset(ext_ex),
        .br(f),
        .C(C),
        .op(npc_op_ex),
        .npc(npc2pc),
        .pc4(pc4));

  IF if_id(
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .pc4_i(pc4),
       .inst_i(inst),
       .pc_i(pc),
       .pc4_o(pc4_id),
       .inst_o(inst_id),
       .pc_o(pc_id)
     );

  SEXT U_sext(
         .op(sext_op),
         .din(inst_id[31:7]),
         .ext(ext)
       );

  RF U_rf(
       .rR1(inst_id[19:15]),
       .rR2(inst_id[24:20]),
       .wR(inst_id[11:7]),
       .wD(wD),
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .op(rf_we),
       .rD1(rD1),
       .rD2(rD2)
     );
    

  
     
  ID id_ex(
.clk_i(cpu_clk),
.rst_i(cpu_rst),
.npc_op_i(npc_op),
.ram_we_i(ram_we),
.rf_wsel_i(rf_wsel),
.alu_op_i(alu_op),
.alua_i(A),
.alub_i(B),
.ext_i(ext),
.rD2_i(rD2),
.npc_op_o(npc_op_ex),
.ram_we_o(ram_we_ex),
.rf_wsel_o(rf_wsel_ex),
.alu_op_o(alu_op_ex),
.alua_o(A_ex),
.alub_o(B_ex),
.ext_o(ext_ex),
.rD2_o(rD2_ex)
  );

  ALU U_alu(
        .A(A_ex),
        .B(B_ex),
        .op(alu_op_ex),
        .C(C),
        .f(f)
      );

wire [31:0]C_mem;
wire [31:0]rD2_mem;
wire [1:0]rf_wsel_mem;
wire ram_we_mem;

EX ex_mem(
.clk_i(cpu_clk),
.rst_i(cpu_rst),
.aluc_i(C),
.rD2_i(rD2_ex),
.rf_wsel_i(rf_wsel_ex),
.ram_we_i(ram_we_ex),
.aluc_o(C_mem),
.rD2_o(rD2_mem),
.rf_wsel_o(rf_wsel_mem),
.ram_we_o(ram_we_mem)
    );
    
wire [31:0] rdo_rb;
wire [1:0]rf_wsel_rb;   


MEM mem_rb(
.clk_i(cpu_clk),
.rst_i(cpu_rst),
.rdo_i(rdo),
.rf_wsel_mem(rf_wsel_mem),
.rdo_o(rdo_rb),
.rf_wsel_rb(rf_wsel_rb)
);


  MUX2 U_mux2_a(
         .i1(pc_id),
         .i2(rD1),
         .o(A),
         .sel(alua_sel)
       );

  MUX2 U_mux2_b(
         .i1(ext),
         .i2(rD2),
         .o(B),
         .sel(alub_sel)
       );

  MUX4 U_mux4_rf(
         .i1(rdo_rb),
         .i2(pc4_id),
         .i3(C),
         .i4(ext),
         .op(rf_wsel_rb),
         .o(wD)
       );


  CONTROLER U_controler(
              .opcode(inst_id[6:0]),
              .funct3(inst_id[14:12]),
              .funct7(inst_id[31:25]),
              .npc_op(npc_op),
              .rf_wsel(rf_wsel),
              .ram_we(ram_we),
              .alu_op(alu_op),
              .alua_sel(alua_sel),
              .alub_sel(alub_sel),
              .sext_op(sext_op),
              .rf_we(rf_we)
            );


  assign inst_addr=pc[15:2];


  assign Bus_wdata=rD2_mem;
  assign Bus_wen=ram_we_mem;

`ifdef RUN_TRACE
  // Debug Interface
  assign debug_wb_have_inst = 1;
  assign debug_wb_pc        = pc;
  assign debug_wb_ena       = rf_we;
  assign debug_wb_reg       = inst[11:7];
  assign debug_wb_value     = wD;
`endif

endmodule
