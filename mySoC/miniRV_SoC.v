`timescale 1ns / 1ps

`include "defines.vh"

module miniRV_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,

    input  wire [23:0]  switches,
    input  wire [ 4:0]  button,
    output wire [ 7:0]  dig_en,
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP,
    output wire [23:0]  led

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst, // ��ǰʱ�������Ƿ���ָ��д?? (�Ե�����CPU�����ڸ�λ�����1)
    output wire [31:0]  debug_wb_pc,        // ��ǰд�ص�ָ���PC (��wb_have_inst=0�������Ϊ����???)
    output              debug_wb_ena,       // ָ��д��ʱ���Ĵ����ѵ�дʹ�� (��wb_have_inst=0�������Ϊ����???)
    output wire [ 4:0]  debug_wb_reg,       // ָ��д��ʱ��д��ļĴ���?? (��wb_ena��wb_have_inst=0�������Ϊ����???)
    output wire [31:0]  debug_wb_value      // ָ��д��ʱ��д��Ĵ�����?? (��wb_ena��wb_have_inst=0�������Ϊ����???)
`endif
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;

    // Interface between CPU and IROM
`ifdef RUN_TRACE
    wire [15:0] inst_addr;
`else
  wire [13:0] inst_addr;
`endif
    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_wen;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         wen_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    // Interface between bridge and peripherals
    // TODO: �ڴ˶���������������I/O�ӿڵ�·ģ���������??
    //
     // Interface to 7-seg digital LEDs
        wire rst_bridge2dig;
        wire clk_bridge2dig;
        wire [11:0] addr_bridge2dig;
         wire wen_bridge2dig;
         wire [31:0] wdata_bridge2dig;
 

        // Interface to LEDs
       wire rst_bridge2led;
        wire clk_bridge2led;
        wire [11:0] addr_bridge2led;
         wire wen_bridge2led;
        wire [31:0]wdata_bridge2led;

        // Interface to switches
       wire rst_bridge2sw;
        wire clk_bridge2sw;
        wire [11:0] addr_bridge2sw;
        wire [31:0]rdata_bridge2sw;

        // Interface to buttons
       wire rst_bridge2btn;
        wire clk_bridge2btn;
        wire [11:0] addr_bridge2btn;
        wire [31:0]rdata_bridge2btn;


    
`ifdef RUN_TRACE
    // Trace����ʱ��ֱ��ʹ���ⲿ����ʱ��
    assign cpu_clk = fpga_clk;
`else
    // �°�ʱ��ʹ��PLL��Ƶ���ʱ��
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (!fpga_rst),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
`endif
    
    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_wen            (Bus_wen),
        .Bus_wdata          (Bus_wdata)

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    
    IROM Mem_IROM (
        .a          (inst_addr),
        .spo        (inst)
    );
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (fpga_rst),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .wen_from_cpu       (Bus_wen),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .wen_to_dram        (wen_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
         // Interface to 7-seg digital LEDs
        .rst_to_dig         (rst_bridge2dig),
        .clk_to_dig         (clk_bridge2dig),
        .addr_to_dig        (addr_bridge2dig),
        .wen_to_dig         (wen_bridge2dig),
        .wdata_to_dig       (wdata_bridge2dig),

        // Interface to LEDs
        .rst_to_led         (rst_bridge2led),
        .clk_to_led         (clk_bridge2led),
        .addr_to_led        (addr_bridge2led),
        .wen_to_led         (wen_bridge2led),
        .wdata_to_led       (wdata_bridge2led),

        // Interface to switches
        .rst_to_sw          (rst_bridge2sw),
        .clk_to_sw          (clk_bridge2sw),
        .addr_to_sw         (addr_bridge2sw),
        .rdata_from_sw      (rdata_bridge2sw),

        // Interface to buttons
        .rst_to_btn         (rst_bridge2btn),
        .clk_to_btn         (clk_bridge2btn),
        .addr_to_btn        (addr_bridge2btn),
        .rdata_from_btn     (rdata_bridge2btn)
    );

    //wire [13:0] waddr_tmp = addr_bridge2dram[15:2] - 16'h4000;
    wire [15:0] waddr_tmp = addr_bridge2dram[15:0];// - 16'h4000;
    DRAM Mem_DRAM (
        .clk        (clk_bridge2dram),
        .a          (waddr_tmp[15:2]),
        .spo        (rdata_dram2bridge),
        .we         (wen_bridge2dram),
        .d          (wdata_bridge2dram)
    );
    
    // TODO: �ڴ�ʵ�����������I/O�ӿڵ�·ģ��
    //
    DIG8 U_dig(
            .clk_i(clk_bridge2dig),
            .rst_i(rst_bridge2dig),
            .addr(addr_bridge2dig),
            .wdata(wdata_bridge2dig),
            .wen(wen_bridge2dig),
            .dig_en(dig_en),
            .dig_data({DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP})
        );
    
    LED U_leds(
        .clk_i(clk_bridge2led),
        .rst_i(rst_bridge2led),
        .wen(wen_bridge2led),
        .addr(addr_bridge2led),
        .wdata(wdata_bridge2led),
        .led(led)
    );
    
    SWITCHES U_sw(
    .clk_i(clk_bridge2sw),
    .rst_i(rst_bridge2sw),
    .addr(addr_bridge2sw),
    .rdata(rdata_bridge2sw),
    .data_sw(switches)
    );
    
    BUTTON U_btn(
    .clk_i(clk_bridge2btn),
    .rst_i(rst_bridge2btn),
    .addr(addr_bridge2btn),
    .rdata(rdata_bridge2btn),
    .btn(button)
    );


endmodule
