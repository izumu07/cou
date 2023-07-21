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
  
 
  

  
  


  wire pause;
  
  wire pause_ex;
  wire pause_mem;
  wire pause_rb;

  
  


  

  //！！！取指单元  IF！！！
  wire [31:0]pc4;
  wire [31:0]pc;
  
  assign pc4=pc+4;
  
  wire [31:0]pc_id;
  wire [31:0]inst_id;
  
  
  wire [31:0]npc;
  assign npc=flush?npc2pc:(pause?pc:pc4);
    
  wire flush;


  
  PC U_PC(
       .din(npc),
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .pc(pc)
     );

  

  IF U_if2id(
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .pause(pause|flist[4]),
       .flush(0),
       
       .inst_i(inst),
       .pc_i(pc),
       .inst_o(inst_id),
       .pc_o(pc_id)
     );

  assign inst_addr=pc[15:2];    //传入irom取址

  //！！！译码单元 ID！！！
  
  
    
  //立即数拓展单元  
  /* verilator lint_off UNOPTFLAT */
  wire [31:0]ext;
  /* verilator lint_off UNOPTFLAT */
  
  wire [2:0]sext_op;
     
  SEXT U_sext(
         .op(sext_op),
         .din(inst_id[31:7]),
         .ext(ext)
       );
       
  //RF写操作（写回阶段）： 先前指令的写寄存器、写数据和写使能
  wire [4:0]wR_rb;
  wire [31:0]wD_rb;
  wire rf_we_rb;
  
  //RF读操作 ：传入后续阶段
  wire [31:0]rD1;
  wire [31:0]rD2;
  
  
  
  //寄存器组
  RF U_rf(
       .rR1(inst_id[19:15]),
       .rR2(inst_id[24:20]),
       .rD1(rD1),
       .rD2(rD2),

       .wR(wR_rb),
       .wD(wD_rb),
       .op(rf_we_rb),

       .clk_i(cpu_clk),
       .rst_i(cpu_rst)
     );
  
  //传入之后阶段信号（当前指令的写寄存器、写使能） 
  wire [4:0]wR;
  assign wR=inst_id[11:7];
  

  
  
  //控制单元
  wire [1:0]npc_op;
  
  wire alua_sel;
  wire alub_sel;
  wire [3:0]alu_op;
  
  wire ram_we;
  
  wire rf_we;
  wire [1:0]rf_wsel;
  
  wire rf_we_ex;
  wire [1:0]rf_wsel_ex;
  wire [4:0]wR_ex;
  
  wire [31:0]pc_ex;
  wire [1:0]npc_op_ex;
  
  wire ram_we_ex;
  wire[3:0] alu_op_ex;
  wire[31:0] A_ex;
  wire [31:0]B_ex;
  wire[31:0] ext_ex;
  wire  [31:0]rD1_ex;
  wire [31:0]rD2_ex;
    
  
  CONTROLER U_controler(
              .opcode(inst_id[6:0]),
              .funct3(inst_id[14:12]),
              .funct7(inst_id[31:25]),
              
              .npc_op(npc_op),
              
              .alua_sel(alua_sel),
              .alub_sel(alub_sel),
              .sext_op(sext_op),
              
              .alu_op(alu_op),
              
              .ram_we(ram_we),
              
              .rf_wsel(rf_wsel),
              .rf_we(rf_we)  
            );
  
  //求取ALU输入A和B
  wire [31:0] A;
  wire [31:0] B;
  
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

  ID U_id2ex(
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .pause(pause_ex||flist[3]),
       .flush(0),
       
       .pc_i(pc_id),
       .npc_op_i(npc_op),
       
       .alu_op_i(alu_op),
       .alua_i(A),
       .alub_i(B),
       
       .ram_we_i(ram_we),
       
       .wR_i(wR),
       .rf_wsel_i(rf_wsel),
       .rf_we_i(rf_we),
       
       .ext_i(ext),
       .rD2_i(rD2),
       
       .pc_o(pc_ex),
       .npc_op_o(npc_op_ex),
       
       .ram_we_o(ram_we_ex),
       
       .wR_o(wR_ex),
       .rf_wsel_o(rf_wsel_ex),
       .rf_we_o(rf_we_ex),
       
       .alu_op_o(alu_op_ex),
       .alua_o(A_ex),
       .alub_o(B_ex),
       
       .ext_o(ext_ex),
       .rD2_o(rD2_ex)
     );
     
  //！！！执行单元 EX！！！

  wire [31:0]C_mem;
  wire [31:0] C;
  wire f;
  
  ALU U_alu(
        .A(A_ex),
        .B(B_ex),
        .op(alu_op_ex),
        .C(C),
        .f(f)
      );
      
  wire [31:0]pc4_ex;
  wire [31:0]npc2pc;
  
  NPC U_NPC(
        .pc(pc_ex),
        .offset(ext_ex),
        .C(C),
        .br(f),
        .op(npc_op_ex),
        .npc(npc2pc),
        .pc4(pc4_ex));
  
  wire [31:0]rD2_mem;
  wire [31:0]ext_mem;
  wire [31:0]pc4_mem;
  
  wire [4:0]wR_mem;
  wire [1:0]rf_wsel_mem;
  wire rf_we_mem;
  
  wire ram_we_mem;

  EX U_ex2mem(
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .pause(pause_mem|flist[2]),
       
       .aluc_i(C),
       .rD2_i(rD2_ex),
       .ext_i(ext_ex),
       .pc4_i(pc4_ex),
       
       .wR_i(wR_ex),       
       .rf_wsel_i(rf_wsel_ex),
       .rf_we_i(rf_we_ex),
       
       .ram_we_i(ram_we_ex),
       
       
       .aluc_o(C_mem),
       .rD2_o(rD2_mem),
       .ext_o(ext_mem),
       .pc4_o(pc4_mem),
       
       .wR_o(wR_mem), 
       .rf_wsel_o(rf_wsel_mem),
       .rf_we_o(rf_we_mem),
       
       .ram_we_o(ram_we_mem)
     );
  
  
  //！！！访存单元 MEM！！！
  wire [31:0] rdo_rb;
  wire [1:0]rf_wsel_rb;

  //读DRAM
  wire [31:0]rdo;
  assign rdo=Bus_rdata;
  
  //写DRAM
  assign Bus_addr=C_mem;
  assign Bus_wdata=rD2_mem;
  assign Bus_wen=ram_we_mem;
  
  wire  [31:0]wD;
  
  MUX4 U_mux4_rf(
         .i1(rdo),
         .i2(pc4_mem),
         .i3(C_mem),
         .i4(ext_mem),
         .op(rf_wsel_mem),
         .o(wD)
       );
  
  
  MEM U_mem2rb(
        .clk_i(cpu_clk),
        .rst_i(cpu_rst),
        .pause(pause_rb),
        
        .wD_i(wD),
        .wR_i(wR_mem),
        .rf_we_i(rf_we_mem),
        
        .wD_o(wD_rb),
        .wR_o(wR_rb),
        .rf_we_o(rf_we_rb)
      );



    CONTROLPIPE U_ctrlp(
      .clk_i(cpu_clk),
      .rst_i(cpu_rst),
 .pc_i(pc),
.npc_i(npc2pc),
.rs1_i(inst_id[19:15]),
.rs2_i(inst_id[24:20]),
.rf_we_ex(rf_we_ex),
.rf_we_mem(rf_we_mem),
.rf_we_rb(rf_we_rb),
.wR_ex(wR_ex),
.wR_mem(wR_mem),
.wR_rb(wR_rb),
.opc(inst_id[6:2]),
.npc_o(),
.pause(pause),
.pause_ex(pause_ex),
.pause_mem(pause_mem),
.pause_rb(pause_rb)

    );

wire [1:0]npc_pred;
wire [4:0]flist;
assign npc_pred=inst[6]?inst[3:2]:2'b10;

BRANCH U_brc(
.clk_i(cpu_clk),
.rst_i(cpu_rst),
.pred(npc_pred),
.flush(flush),
.flist(flist)
);


  


  



  

`ifdef RUN_TRACE
  


  // Debug Interface
  assign debug_wb_have_inst = ((wR_rb!==0)&(!pause_rb));
  assign debug_wb_pc        = pc-4;
  assign debug_wb_ena       = rf_we_rb;
  assign debug_wb_reg       = wR_rb;
  assign debug_wb_value     = wD_rb;
`endif


endmodule
    