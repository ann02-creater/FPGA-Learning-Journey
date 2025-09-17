module mux_4bit(
output [3:0] out,
input [3:0] i0, i1, i2, i3,
input [1:0] s
):
mux4_1 m0(
.out(out[0]), 
.i({i3[0], i2[0], i1[0], i0[0]}), 
.s(s));

mux4_1 m1(
.out(out[1]), 
.i({i3[1], i2[1], i1[1], i0[1]}), 
.s(s));

mux4_1 m2(
.out(out[2]), 
.i({i3[2], i2[2], i1[2], i0[2]}), 
.s(s));

mux4_1 m3(
.out(out[3]), 
.i({i3[3], i2[3], i1[3], i0[3]}), 
.s(s));


endmodule