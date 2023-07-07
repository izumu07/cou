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
    
    

    
    PC myPC(
.din(npc2pc),
.clk_i(cpu_clk),
.rst_i(cpu_rst),
.pc(pc)
    );
    
    NPC myNPC(
    .pc(pc),
.offset(ext),
.br(f),
.C(C),
.op(npc_op),
.npc(npc2pc),
.pc4(pc4));

    SEXT sext(
    .op(sext_op),
.din(inst[31:7]),
.ext(ext)
    );
    
    RF rf(
    .rR1(inst[19:15]),
.rR2(inst[24:20]),
.wR(inst[11:7]),
.wD(wD),
.clk_i(cpu_clk),
.rst_i(cpu_rst),
.op(rf_we),
.rD1(rD1),
.rD2(rD2)
    );
    
    ALU alu(
    .A(A),
.B(B),
.op(alu_op),
.C(C),
.f(f)
    );
    
    MUX2 alua(
    .i1(pc),
    .i2(rD1),
    .o(A),
    .sel(alua_sel)
    );
    
     MUX2 alub(
    .i1(ext),
    .i2(rD2),
    .o(B),
    .sel(alub_sel)
    );
    
    MUX4 mux4rf(
    .i1(rdo),
    .i2(pc4),
    .i3(C),
    .i4(ext),
    .op(rf_wsel),
    .o(wD)
    );

    
    CONTROLER controler(
.opcode(inst[6:0]),
.funct3(inst[14:12]),
.funct7(inst[31:25]),
.npc_op(npc_op),
.rf_wsel(rf_wsel),
.ram_we(ram_we),
.alu_op(alu_op),
.alua_sel(alua_sel),
.alub_sel(alub_sel),
.sext_op(sext_op),
.rf_we(rf_we) 
    );
    
    assign inst_addr=pc;
    assign Bus_wdata=rD2;
    assign Bus_wen=ram_we;

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1;
    assign debug_wb_pc        = pc;
    assign debug_wb_ena       = rf_we;
    assign debug_wb_reg       = inst[11:7];
    assign debug_wb_value     = wD;
`endif

endmodule
