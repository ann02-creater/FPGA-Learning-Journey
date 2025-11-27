`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Cheolho Kang
// 
// Create Date:    12:39:06 11/29/2014 
// Design Name: 
// Module Name:    clk_gen_25Mhz 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_gen_25Mhz(
    input wire clk50Mhz,    // Actually 100MHz now
    input wire clk_en,
    input wire rst,
    output reg clk25Mhz
    );

// Counter for 100MHz -> 25MHz conversion
// 100MHz / 25MHz = 4, so toggle every 2 cycles
reg clk25Mhz_next;

always @(posedge clk50Mhz, posedge rst)
	if (rst)
		clk25Mhz <= 0;
	else if(clk_en) begin
		clk25Mhz <= clk25Mhz + 1;
	end

endmodule
