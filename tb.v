module tb();
wire out;

reg [3:0] data0, data1, data2, data3;
reg [1:0] s;
wire [6:0] seg_out;

top uut(
.data0(data0),
.data1(data1),
.data2(data2),
.data3(data3),
.s(s),
.out(seg_out)
);

initial begin
 data0 = 4'h4;
 data1 = 4'h3;
 data2 = 4'hA;
 data3 = 4'hb;

sel = 2'b00; 
#100
 $display(seg_out)
sel = 2'b01;
#100
 $display(seg_out)
sel = 2'b10;
#100
 $display(seg_out)
sel = 2'b11;
#100
$display(seg_out)

$finish;
end
endmodule