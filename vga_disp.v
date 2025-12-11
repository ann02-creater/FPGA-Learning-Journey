`timescale 1ns / 1ps

module vga_display(
    input wire clk,
    input wire clk_en,
    input wire rst,
    output reg [9:0] hcnt,
    output reg [9:0] vcnt,
    output reg hsyncb,
    output reg vsyncb,
    output wire detect_neg_vsyncb,
    output reg video_off,
    input wire en,
    input wire en2
    );

reg vsyncb_1, vsyncb_2, vsyncb_3, vsyncb_4, vsyncb_5;
reg hsyncb_1, hsyncb_2, hsyncb_3, hsyncb_4, hsyncb_5;

localparam [9:0] H_TOTAL_CNT = 799;
localparam [9:0] V_TOTAL_CNT = 524;

localparam [9:0] ACTIVE_VIDEO_TIC = 640;
localparam [9:0] FRONT_PORCH_TIC = 16;
localparam [9:0] HRZ_SYNC_TIC = 96;
localparam [9:0] BACK_PORCH_TIC = 48;

localparam [9:0] ACTIVE_VERT_LINE = 480;
localparam [9:0] FRONT_PORCH_LINE = 10;
localparam [9:0] VERT_SYNC_LINE = 2;
localparam [9:0] BACK_PORCH_LINE = 29;

reg buf_hsyncb, buf_vsyncb;

always @(posedge clk, posedge rst)
    if (rst)
        hcnt <= 10'b0;
    else if (clk_en) begin
        if(en2 == 1) begin
            if (hcnt < H_TOTAL_CNT && en == 1'b1)
                hcnt <= hcnt + 1'b1;
            else 
                hcnt <= 10'b0;
        end
    end

always @(posedge clk, posedge rst)
    if (rst)
        buf_hsyncb <= 1'b1;
    else if (clk_en && en2)
        buf_hsyncb <= hsyncb;

always @(posedge clk, posedge rst)
    if (rst)
        vcnt <= 10'b0;
    else if (clk_en) begin
        if(en2 == 1) begin
            if (hcnt == 799)
                if (vcnt < V_TOTAL_CNT && en == 1'b1)
                    vcnt <= vcnt + 1'b1;
                else
                    vcnt <= 10'b0;
        end    
    end

always @(posedge clk, posedge rst)
    if (rst) 
        hsyncb <= 1'b1;
    else if (clk_en) begin
        if (en2)
            if ((hcnt > 656 + 48) && (hcnt < 656 + 48 + HRZ_SYNC_TIC))
                hsyncb <= 1'b0;
            else
                hsyncb <= 1'b1;
    end

always @(posedge clk, posedge rst)
    if (rst) 
        vsyncb <= 1'b1;
    else if (clk_en) begin
        if ((vcnt > 489) && (vcnt < 490 + VERT_SYNC_LINE))
            vsyncb <= 1'b0;
        else
            vsyncb <= 1'b1;
    end

always @(posedge clk, posedge rst) begin
    if (rst)
        video_off <= 1'b1;
    else if (clk_en) begin
        if (vcnt > 479 && vcnt < V_TOTAL_CNT)
            video_off <= 1'b1;
        else
            video_off <= 1'b0;
    end
end

always @(posedge clk, posedge rst)
    if (rst)
        buf_vsyncb <= 1'b0;
    else if (clk_en & en2)
        buf_vsyncb <= ~vsyncb;
        
assign detect_neg_vsyncb = (~buf_vsyncb & ~vsyncb);

endmodule
