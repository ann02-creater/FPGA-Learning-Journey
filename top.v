`timescale 1ns / 1ps

module top_blk_vga(
    // crystal
    input            clk,          // 100MHz clock input
    // buttons
    input            rst,          // Active HIGH reset (BTNC)
    input            enable_memw,  // unused now
    input            enable_vga,   // VGA enable (BTNL)
    // slide switches
    input      [3:0] sw,           // SW[3:0]
    input            ps2_clk,      // PS2 clock
    input            ps2_data,     // PS2 data
    // VGA pins
    output     [7:0] rgb,
    output           hsyncb,
    output           vsyncb
);

    // internal clocks
    wire clk_100;
    wire clk_50;
    // PS2 keyboard
    wire [7:0] kbd_code;
    wire       kbd_ready;
    // virtual switches from keyboard
    reg  [2:0] y_step;       // replaces SW[3:1]
    reg        got_f0;       // F0 break code handler
    wire [3:0] virtual_sw;   // output to TOP_VGA

    // debounced VGA enable toggle
    wire enable_vga_tg;

    // BRAM <-> VGA interface
    wire [18:0] mem_addr;
    wire [7:0]  mem_data;

    // ───────────────────────────────
    // 1. Clocking Wizard (100MHz -> 100/50MHz)
    // ───────────────────────────────
    clk_wiz_0 clk_core (
        .clk_in1(clk),
        .clk_out1(clk_100),
        .clk_out2(clk_50),
        .reset(rst)
    );

    // ───────────────────────────────
    // 2. Block RAM (Image ROM)
    //    Port A : unused (constant)
    //    Port B : VGA read only
    // ───────────────────────────────
    blk_mem_gen_0 frame_buffer (
        // Port A : write port (disabled, constant)
        .clka (clk_100),
        .wea  (1'b0),
        .addra(19'd0),
        .dina (8'd0),
        .douta(),

        // Port B : read port (for VGA)
        .clkb (clk_50),
        .web  (1'b0),
        .addrb(mem_addr),
        .dinb (8'h00),
        .doutb(mem_data)
    );
    
    ps2_keyboard kbd (
        .clk      (clk_50),
        .rst      (rst),
        .ps2_clk  (ps2_clk),
        .ps2_data (ps2_data),
        .scan_code(kbd_code),
        .scan_ready(kbd_ready)
    );

    // ───────────────────────────────
    // 3. VGA Top module
    // ───────────────────────────────
    TOP_VGA vga (
        .clk    (clk_50),
        .clk_en (enable_vga_tg),
        .rst    (rst),
        .din    (mem_data),
        .WES    (),
        .dout   (),
        .addr   (mem_addr),
        .rgb    (rgb),
        .hsyncb (hsyncb),
        .vsyncb (vsyncb),
        .sw     (virtual_sw)
    );

    // ───────────────────────────────
    // 4. VGA enable button debounce/toggle
    // ───────────────────────────────
    debounce debounce_vga (
        .clk    (clk_100),
        .rst    (rst),
        .din    (enable_vga),
        .tick   (),
        .toggle (enable_vga_tg)
    );

    // Keyboard + / - keys to control y_step
    // PS/2 set2: keypad '+' = 0x79, keypad '-' = 0x7B
    // (main keyboard '+'(0x55), '-'(0x4E) also allowed)
    localparam [7:0] KEY_PLUS_1  = 8'h79;
    localparam [7:0] KEY_PLUS_2  = 8'h55;
    localparam [7:0] KEY_MINUS_1 = 8'h7B;
    localparam [7:0] KEY_MINUS_2 = 8'h4E;

    always @(posedge clk_50 or posedge rst) begin
        if (rst) begin
            y_step <= 3'd0;
            got_f0 <= 1'b0;
        end else if (kbd_ready) begin
            if (!got_f0 && kbd_code == 8'hF0) begin
                // next code is key release, mark for skip
                got_f0 <= 1'b1;
            end else begin
                if (!got_f0) begin
                    // only act on key press
                    case (kbd_code)
                        KEY_PLUS_1,
                        KEY_PLUS_2: begin
                            if (y_step != 3'd7)
                                y_step <= y_step + 1'b1;
                        end
                        KEY_MINUS_1,
                        KEY_MINUS_2: begin
                            if (y_step != 3'd0)
                                y_step <= y_step - 1'b1;
                        end
                        default: ;
                    endcase
                end
                got_f0 <= 1'b0;
            end
        end
    end

    // TOP_VGA expects sw[3:0] format
    // sw[0] = always 1 (image always on)
    // sw[3:1] = y_step (row movement step, 32 pixel unit)
    assign virtual_sw = {y_step, 1'b1};

endmodule