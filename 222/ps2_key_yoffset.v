`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simple PS/2 scanner and Y-offset controller
// Captures PS/2 make codes and bumps a 4-bit row offset on keypad +/- presses.
//////////////////////////////////////////////////////////////////////////////////

module ps2_scancode (
    input  wire clk,
    input  wire rst,
    input  wire ps2_clk,
    input  wire ps2_data,
    output reg  [7:0] scancode,
    output reg  scancode_ready
    );

reg [2:0] ps2c_sync;
reg [3:0] bit_count;
reg [10:0] shift;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ps2c_sync <= 0;
        bit_count <= 0;
        shift <= 0;
        scancode <= 0;
        scancode_ready <= 0;
    end else begin
        // sync PS/2 clock into clk domain to detect falling edges
        ps2c_sync <= {ps2c_sync[1:0], ps2_clk};
        scancode_ready <= 1'b0;

        if (ps2c_sync[2:1] == 2'b10) begin  // detect falling edge
            shift[bit_count] <= ps2_data;
            if (bit_count == 4'd10) begin
                bit_count <= 0;
                scancode <= shift[8:1];
                scancode_ready <= 1'b1;
            end else begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end
end
endmodule

module y_offset_ctrl #(
    parameter MAX_STEP = 4'd14  // 14 * 32 = 448 pixels, fits in 480p
    )(
    input  wire clk,
    input  wire rst,
    input  wire [7:0] scancode,
    input  wire scancode_ready,
    output reg  [3:0] y_offset
    );

localparam SC_BREAK = 8'hF0;
localparam SC_PLUS  = 8'h79; // keypad '+'
localparam SC_MINUS = 8'h7B; // keypad '-'

reg break_seen;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        y_offset <= 0;
        break_seen <= 1'b0;
    end else begin
        if (scancode_ready) begin
            if (scancode == SC_BREAK) begin
                break_seen <= 1'b1;
            end else begin
                if (!break_seen) begin
                    if (scancode == SC_PLUS && y_offset < MAX_STEP)
                        y_offset <= y_offset + 1'b1;
                    else if (scancode == SC_MINUS && y_offset > 0)
                        y_offset <= y_offset - 1'b1;
                end
                break_seen <= 1'b0;
            end
        end
    end
end
endmodule
