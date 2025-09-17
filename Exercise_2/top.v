module top(
    input data0, data1, data2, data3,
    input [1:0] s,
    output [6:0] out
);
wire [3:0] selected_data;

assign selected_data={data3, data2, data1, data0};


ss_decoder d0(
.in(selected_data), 
.out(out)
);
endmodule
