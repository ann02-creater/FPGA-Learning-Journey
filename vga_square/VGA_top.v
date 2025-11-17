module VGA_top(
    input CLK100MHZ, reset,
    output VGA_HS, VGA_VS,
    output [11:0] vga
    );
    
    localparam COLOR_WHITE  = 12'b1111_1111_1111;
    localparam COLOR_RED = 12'b0000_0000_1111;
    localparam COLOR_BLUE   = 12'b1111_0000_0000;
    localparam COLOR_GREEN  = 12'b0000_1111_0000;
    localparam COLOR_YELLOW = 12'b0000_1111_1111;
    localparam COLOR_BLACK  = 12'b0000_0000_0000;
    
    localparam BLOCK_WIDTH  = 50;
    localparam BLOCK_HEIGHT = 50;

    localparam BLOCK_WIDTH_1  = 30;
    localparam BLOCK_HEIGHT_1 = 300;
    
    localparam BLOCK_S_X    = 50;
    localparam BLOCK_S_Y    = 50;
    localparam BLOCK_B1_X = 200;
    localparam BLOCK_B1_Y = 0;
    localparam BLOCK_B2_X = 400;
    localparam BLOCK_B2_Y = 100;
    localparam BLOCK_Y3_X = 500;
    localparam BLOCK_Y3_Y = 300;
    
    wire video_on,  block_on;
    wire pixel_clk;

    wire [9:0] pixel_x, pixel_y;

    reg [11:0] vga_next, vga_reg;
    
    VGA_controller VGA_controller_1(
        .clk(CLK100MHZ), .reset(reset),
        .hsync(VGA_HS), .vsync(VGA_VS),
        .video_on(video_on), .pixel_clk(pixel_clk),
        .pixel_x(pixel_x), .pixel_y(pixel_y)
    );

    always @(posedge CLK100MHZ, posedge reset)
    begin
        if(reset)
            vga_reg <= 12'd0;
        else
            if(pixel_clk)
                vga_reg <= vga_next;
    end

    always @*
    begin
        vga_next = vga_reg;
        if(~video_on)
            vga_next = COLOR_BLACK;
        else
        begin
            if(block_on)
            if((BLOCK_S_X <= pixel_x ) && (pixel_x < BLOCK_S_X + BLOCK_WIDTH)
               && (BLOCK_S_Y <= pixel_y) && (pixel_y < BLOCK_S_Y + BLOCK_HEIGHT))
                vga_next = COLOR_RED;
            else if((BLOCK_B1_X <= pixel_x ) && (pixel_x < BLOCK_B1_X + BLOCK_WIDTH_1)
                     && (BLOCK_B1_Y <= pixel_y) && (pixel_y < BLOCK_B1_Y + BLOCK_HEIGHT_1))
                vga_next = COLOR_BLUE;
            else if((BLOCK_B2_X <= pixel_x ) && (pixel_x < BLOCK_B2_X + BLOCK_WIDTH_1)
                     && (BLOCK_B2_Y <= pixel_y) && (pixel_y < BLOCK_B2_Y + BLOCK_HEIGHT_1))  
                vga_next = COLOR_BLUE;
            else if((BLOCK_Y3_X <= pixel_x ) && (pixel_x < BLOCK_Y3_X + BLOCK_WIDTH)
                     && (BLOCK_Y3_Y <= pixel_y) && (pixel_y < BLOCK_Y3_Y + BLOCK_HEIGHT))  
                vga_next = COLOR_YELLOW;
            else
                vga_next =  COLOR_GREEN;
        end
    end
    
    assign block_on = (BLOCK_S_X <= pixel_x )
                      && (pixel_x < BLOCK_S_X + BLOCK_WIDTH)
                      && (BLOCK_S_Y <= pixel_y)
                      && (pixel_y < BLOCK_S_Y + BLOCK_HEIGHT) 

                      && (BLOCK_B1_X <= pixel_x )   
                        && (pixel_x < BLOCK_B1_X + BLOCK_WIDTH_1)
                        && (BLOCK_B1_Y <= pixel_y)
                        && (pixel_y < BLOCK_B1_Y + BLOCK_HEIGHT_1)

                        && (BLOCK_B2_X <= pixel_x )
                        && (pixel_x < BLOCK_B2_X + BLOCK_WIDTH_1)
                        && (BLOCK_B2_Y <= pixel_y)
                        && (pixel_y < BLOCK_B2_Y + BLOCK_HEIGHT_1)

                        && (BLOCK_Y3_X <= pixel_x )
                        && (pixel_x < BLOCK_Y3_X + BLOCK_WIDTH)
                        && (BLOCK_Y3_Y <= pixel_y)
                        && (pixel_y < BLOCK_Y3_Y + BLOCK_HEIGHT)
                        ;

    assign vga = vga_reg;

endmodule
