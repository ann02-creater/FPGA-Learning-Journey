'define YELLOW 2'd0
'define RED 2'd1
'define GREEN 2'd2

'define S0 2'b00
'define S1 2'b01
'define S2 2'b10
'define S3 2'b11

module sig_controller(hwy,fwy,X,clk,rst);
output [1:0] hwy,fwy;
input clk,rst;
input X;
reg [1:0] hwy,fwy;
reg [1:0] ns, cs;

always @(posedge clk )
 if (rst)  cs <= `S0;
 else cs <= ns;

always @(cs or X) 
case(cs)
    `S0: begin
            if (X) ns = `S1;
            else ns = `S0;
        end
    `S1: ns = `S2;
    `S2: begin
            if (X) ns = `S3;
            else ns = `S0;
        end
    `S3: ns = `S0;
    default: ns = `S0;
endcase
always @(cs)
case(cs)
    `S0: begin
            hwy = `GREEN;
            fwy = `RED;
        end
    `S1: begin
            hwy = `YELLOW;
            fwy = `RED;
        end
    `S2: begin
            hwy = `RED;
            fwy = `RED;
        end
    `S3: begin
            hwy = `RED;
            fwy = `GREEN;
        end
endcase

endmodule