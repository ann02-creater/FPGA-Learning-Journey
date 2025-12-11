`timescale 1ns / 1ps


module ps2_keyboard(
    input  wire clk,       // 50MHz or 100MHz
    input  wire rst,
    input  wire ps2_clk,
    input  wire ps2_data,
    output reg  [7:0] scan_code,
    output reg        scan_ready
);

    // ps2_clk sync + falling edge detect
    reg [2:0] ps2c_sync;
    always @(posedge clk or posedge rst) begin
        if (rst)
            ps2c_sync <= 3'b111;
        else
            ps2c_sync <= {ps2c_sync[1:0], ps2_clk};
    end

    wire negedge_ps2clk = (ps2c_sync[2:1] == 2'b10); // 1->0

    // 11bit frame: start + 8 data + parity + stop
    reg [3:0]  bit_count;
    reg [10:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count  <= 4'd0;
            shift_reg  <= 11'd0;
            scan_code  <= 8'd0;
            scan_ready <= 1'b0;
        end else begin
            scan_ready <= 1'b0;

            if (negedge_ps2clk) begin
                if (bit_count == 4'd0) begin
                    bit_count <= bit_count + 1'b1; // start
                end else if (bit_count <= 4'd8) begin
                    shift_reg[bit_count-1] <= ps2_data; // data
                    bit_count <= bit_count + 1'b1;
                end else if (bit_count == 4'd9) begin
                    bit_count <= bit_count + 1'b1;      // parity
                end else if (bit_count == 4'd10) begin
                    scan_code  <= shift_reg[7:0];       // complete
                    scan_ready <= 1'b1;
                    bit_count  <= 4'd0;
                end
            end
        end
    end

endmodule
