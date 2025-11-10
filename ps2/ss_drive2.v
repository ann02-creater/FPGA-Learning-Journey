`timescale 1ns / 1ps

module ss_drive(
    input sel,
    input [3:0] data1,
    input [3:0] data0,
    output ssA,
    output ssB,
    output ssC,
    output ssD,
    output ssE,
    output ssF,
    output ssG,
    output ssDP,
    output reg AN7,
    output reg AN6,
    output reg AN5,
    output reg AN4,
    output reg AN3,
    output reg AN2,
    output reg AN1,
    output reg AN0
    );

	
	reg [3:0] data;
    
	always @(*)
		case(sel)
			1'b0 : begin
                data = data0;
				AN7 = 1;
                AN6 = 1;
                AN5 = 1;
                AN4 = 1;
				AN3 = 1;
				AN2 = 1;
				AN1 = 1;
				AN0 = 0 ;
				end 
          default : begin   //1'b1
               data = data1;
               AN7 = 1;
               AN6 = 1;
               AN5 = 1;
               AN4 = 1;
               AN3 = 1;
               AN2 = 1;
               AN1 = 0 ;
               AN0 = 1;
               end 
		endcase
	
	ss_decoder data_decode (
    .Din(data), 
    .a(ssA), 
    .b(ssB), 
    .c(ssC), 
    .d(ssD), 
    .e(ssE), 
    .f(ssF), 
    .g(ssG), 
    .dp(ssDP)
    );

		


endmodule
