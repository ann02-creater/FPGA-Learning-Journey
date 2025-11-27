`timescale 1ns / 1ps
module top_blk_vga(

    //crystal
    input            clk,            // Clock input (100MHz)
    //buttons
    input            rst,            // Active HIGH reset
    input            enable_memw,    // Mem Write enable -> port A enable
    input            enable_vga,     // VGA enable
    //switch
    input     [1:0]   mode,
    // VGA pins
    output    [7:0]   rgb,
    output            hsyncb,
    output            vsyncb
    );
wire clk_100;
wire enable_memw_tick;
wire enable_vga_tg;
wire [18:0]ADDR_vga2mem, ADDR_ctrl2mem;
wire [7:0] D_mem2vga, D_mem2ctrl, D_ctrl2mem;
wire wea;

// Single clock generation - 100MHz
clk_wiz_0 clk_core (
    .clk_in1(clk),
    // Clock out ports
    .clk_out1(clk_100),     // 100MHz output clk
    //control
    .reset(rst)             // input reset
    );

// Single port block RAM (True Dual Port configured as Single Clock)
blk_mem frame_buffer (
    .clka(clk_100),         // input wire clka - shared clock
    .wea(wea),              // input wire [0 : 0] wea
    .addra(ADDR_ctrl2mem),  // input wire [18 : 0] addra
    .dina(D_ctrl2mem),      // input wire [7 : 0] dina
    .douta(D_mem2ctrl),     // output wire [7 : 0] douta
    .clkb(clk_100),         // input wire clkb - same clock as clka
    .web(1'b0),             // input wire [0 : 0] web
    .addrb(ADDR_vga2mem),   // input wire [18 : 0] addrb
    .dinb(8'h00),           // input wire [7 : 0] dinb
    .doutb(D_mem2vga)       // output wire [7 : 0] doutb
    );

TOP_VGA vga(
    .clk(clk_100),          // Changed to 100MHz
    .clk_en(enable_vga_tg),
    .rst(rst),
    .din(D_mem2vga),
    .WES(),
    .dout(),
    .addr(ADDR_vga2mem),
    .rgb(rgb),
    .hsyncb(hsyncb),
    .vsyncb(vsyncb)
    );

debounce debounce_vga(
    .clk(clk_100),
    .rst(rst),
    .din(enable_vga),
    .tick(),
    .toggle(enable_vga_tg)
    );

debounce debounce_memw(
    .clk(clk_100),
    .rst(rst),
    .din(enable_memw),
    .tick(enable_memw_tick),
    .toggle()
    );

mem_ctlr mem_ctrl(
    .clk(clk_100),          // Changed to 100MHz
    .rst(rst),
    .en(enable_memw_tick),
    .din(D_mem2ctrl),
    .mode(mode),
    .we(wea),
    .dout(D_ctrl2mem),
    .addr(ADDR_ctrl2mem)
);
endmodule
