`timescale 1ns / 1ps

module vga_data(
    input wire clk,
    input wire clk_en,
    input wire rst,
    input wire [9:0] imageWidth,
    input wire [8:0] imageHeight,
    input wire [9:0] hcnt,
    input wire [9:0] vcnt,
    input wire [7:0] data,
    input wire [9:0] Xposition1,
    input wire [8:0] Yposition1,
    input wire detect_neg_vsyncb,
    output reg [18:0] addr,
    output reg [7:0] rgb
    );
localparam [9:0] BACK_PORCH_TIC = 48;

reg [1:0] cnt2;
wire [9:0]  bound_x, bound_y;
wire in_x, in_y;
reg [7:0] rgb_buffer;
reg buff;
wire active_region;
wire addr_increment;

assign bound_x = ((Xposition1 + imageWidth) >= 640) ? 640 : (Xposition1 + imageWidth);
assign bound_y = ((Yposition1 + imageHeight) >= 480) ? 480 : (Yposition1 + imageHeight);

assign in_y = ((vcnt >= Yposition1) && (vcnt < bound_y)) ? 1'b1 : 1'b0;
assign in_x = ((hcnt >= (Xposition1 + BACK_PORCH_TIC)) && (hcnt < (bound_x + BACK_PORCH_TIC))) ? 1'b1 : 1'b0; 

assign active_region = (in_x & in_y);

always @(posedge clk, posedge rst)
    if (rst) begin
        rgb_buffer <= 8'b0;
        rgb <= 8'd0;
    end
    else if (clk_en) begin
        if ((active_region == 1) || ((hcnt == bound_x + BACK_PORCH_TIC) && in_y)) begin
            if (cnt2 == 2) begin
                rgb <= data[7:0];
            end
            else if (cnt2 == 0)
                rgb <= data[7:0];
        end
        else begin
            rgb <= 8'd0;
        end
    end

always @(posedge clk, posedge rst)
    if (rst)
        cnt2 <= 2'd0;
    else if (clk_en) begin
        if (active_region == 1) begin
            cnt2 <= cnt2 + 1'b1;
            if (cnt2 == 2'd3)
                cnt2 <= 2'd0;                       
        end
        else 
            cnt2 <= 2'd0;
    end
                
assign addr_increment = ((cnt2 == 2'b10 || cnt2 == 2'b00) && active_region == 1) ? 1'b1 : 1'b0;

always @(posedge clk, posedge rst)
    if (rst) begin
        addr <= 19'b0;
    end
    else if (clk_en) begin
        if (detect_neg_vsyncb == 1'b1) begin
            addr <= 19'b0;
        end
        else if (addr_increment == 1'b1) begin
            addr <= addr + 1'b1;
        end
    end
                

endmodule
