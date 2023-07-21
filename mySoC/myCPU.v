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

  // TODO: ������Լ��ĵ�����CPU���
  //
  
 
  

  
  

  wire [31:0]ext_rb;
  wire[31:0]C_rb;
  wire f_rb;

  


  
  


  

  //������ȡָ��Ԫ  IF������
  wire [31:0]pc4;
  wire [31:0]pc;
  
  assign pc4=pc+4;
  
  wire [31:0]pc_id;
  wire [31:0]inst_id;
  
  


  PC U_PC(
       .din(pc4),
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .pc(pc)
     );

  

  IF U_if2id(
       .clk_i(cpu_clk),
       .rst_i(cpu_rst),
       .inst_i(inst),
       .pc_i(pc),
       .inst_o(inst_id),
       .pc_o(pc_id)
     );

  assign inst_addr=pc[15:2];    //����iromȡַ

  //���������뵥Ԫ ID������
  
  
    
  //��������չ��Ԫ 
  /* verilator lint_off UNOPTFLAT */ 
  wire [31:0]ext;
  /* verilator lint_off UNOPTFLAT */
  
  wire [2:0]sext_op;
     
  SEXT U_sext(
         .op(sext_op),
         .din(inst_id[31:7]),
         .ext(ext)
       );
       
  //RFд������д�ؽ׶Σ��� ��ǰָ���д�Ĵ�����д���ݺ�дʹ��
  wire [4:0]wR_rb;
  wire [31:0]wD_rb;
  wire rf_we_rb;
  
  //RF������ ����������׶�
  wire [31:0]rD1;
  wire [31:0]rD2;
  
  
  
  //�Ĵ�����
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
  
  //����֮��׶��źţ���ǰָ���д�Ĵ�����дʹ�ܣ� 
  wire [4:0]wR;
  assign wR=inst_id[11:7];
  

  
  
  //���Ƶ�Ԫ
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
  
  //��ȡALU����A��B
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
     
  //������ִ�е�Ԫ EX������

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
  
  
  //�������ô浥Ԫ MEM������
  wire [31:0] rdo_rb;
  wire [1:0]rf_wsel_rb;

  //��DRAM
  wire [31:0]rdo;
  assign rdo=Bus_rdata;
  
  //дDRAM
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
        
        .wD_i(wD),
        .wR_i(wR_mem),
        .rf_we_i(rf_we_mem),
        
        .wD_o(wD_rb),
        .wR_o(wR_rb),
        .rf_we_o(rf_we_rb)
      );


`ifdef RUN_TRACE

reg [3:0]cnt;
reg flag;

always @(posedge cpu_clk or posedge cpu_rst) begin
  if (cpu_rst) begin
    cnt<=0;
    flag<=0;
  end
  else if(cnt<4)
    begin
      cnt<=cnt+1;
    end
    else if (cnt==4) begin
      cnt<=cnt;
      flag<=1;
    end
    else
      cnt<=cnt;
end
`endif


  


  

`ifdef RUN_TRACE
  // Debug Interface
  assign debug_wb_have_inst = flag;
  assign debug_wb_pc        = pc-'h10;
  assign debug_wb_ena       = rf_we_rb;
  assign debug_wb_reg       = wR_rb;
  assign debug_wb_value     = wD_rb;
`endif

endmodule
