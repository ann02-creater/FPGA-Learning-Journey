module top(
    input [3:0] data0, data1, data2, data3,
    input [1:0] s,
    output [6:0] out
);
wire [3:0] selected_data;

mux_4bit m0( 
.out(selected_data),
.i0(data0),
.i1(data1),
.i2(data2),
.i3(data3),
.s(s)
);

ss_decoder d0(
.in(selected_data), 
.seg_out(out)
);
endmodule