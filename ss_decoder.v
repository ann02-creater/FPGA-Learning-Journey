module ss_decoder(
    input [3:0] in,
    output reg [6:0] seg_out
);
always@(in) begin
    case(in)
4'd0: out = 7'b1000000;
4'd1: out = 7'b1001111;
4'd2: out = 7'b0100100;
4'd3: out = 7'b0110000;
4'd4: out = 7'b0011001;
4'd5: out = 7'b0010010;
4'd6: out = 7'b0000010;
4'd7: out = 7'b1111000;
4'd8: out = 7'b0000000;
4'd9: out = 7'b0010000;
4'dA: out = 7'b0001000; 
4'dB: out = 7'b0000011; 
4'dC: out = 7'b1000110; 
4'dD: out = 7'b0100001; 
4'dE: out = 7'b0000110; 
4'dF: out = 7'b0001110;
default: out = 7'b1111111; 
    endcase   

end
endmodule