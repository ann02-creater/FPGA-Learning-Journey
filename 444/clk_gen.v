`timescale 1ns / 1ps

module clk_gen_25Mhz(
    input wire clk50Mhz,
    input wire clk_en,
    input wire rst,
    output reg clk25Mhz
    );

always @(posedge clk50Mhz, posedge rst)
    if (rst)
        clk25Mhz <= 1'b0;
    else if(clk_en)
        clk25Mhz <= clk25Mhz + 1'b1;
        
endmodule
