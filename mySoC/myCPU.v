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
    wire [31:0]offset;

    wire [31:0]pc4;
    wire [4:0]rR1;
    wire [4:0]rR2;
    wire [4:0]wR;
    wire [31:0]wD;
    wire [31:0]rD1;
    wire [31:0]ext;
    
    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] C;
    wire f;
    
    
    wire [1:0]npc_op;
    wire [2:0]sext_op;
    wire rf_we;
    wire [3:0] alu_op;
    wire rf_wsel;
    wire alua_sel;
    wire alub_sel;
    
    

    
    PC myPC(
.din(npc2pc),
.clk_i(cpu_clk),
.rst_i(cpu_rst),
.pc(inst_addr)
    );
    
    NPC myNPC(
    .pc(inst_addr),
.offset(offset),
.br(f),
.op(npc_op),
.npc(npc2pc),
.pc4(pc4));

    SEXT sext(
    .op(sext_op),
.din(inst),
.ext(ext)
    );
    
    RF rf(
    .rR1(rR1),
.rR2(rR2),
.wR(wR),
.wD(wD),
.clk_i(cpu_clk),
.rst_i(cpu_rst),
.op(rf_we),
.rD1(rD1),
.rD2(Bus_wdata)
    );
    
    ALU alu(
    .A(A),
.B(B),
.op(alu_op),
.C(C),
.f(f)
    );
    
    MUX2 alua(
    .i1(inst_addr),
    .i2(rD1),
    .o(A)
    );
    
     MUX2 alub(
    .i1(ext),
    .i2(Bus_wdata),
    .o(B)
    );
    
    MUX4 mux4rf(
    .i1(C),
    .i2(ext),
    .i3(pc4),
    .i4(Bus_rdata),
    .op(rf_wsel),
    .o(wD)
    );

    
    CONTROLER(
.opcode(inst[6:0]),
.funct3(inst[14:12]),
.funct7(inst[31:25]),
.npc_op(npc_op),
.rf_wsel(rf_wsel),
.ram_we(Bus_wen),
.alu_op(alu_op),
.alua_sel(alua_sel),
.alub_sel(alub_sel),
.sext_op(sext_op),
.rf_we(rf_we) 
    );
    

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = Bus_wen;
    assign debug_wb_pc        = inst_addr;
    assign debug_wb_ena       = rf_we;
    assign debug_wb_reg       = wR;
    assign debug_wb_value     = Bus_wdata;
`endif

endmodule
