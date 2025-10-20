module tb_1;
reg clk=0
reg rst, X;
wire [1:0] hwy, fwy;

module sig_controller uut(hwy,fwy,X,clk,rst);
initial forever #5 clk=~clk;
initial begin
    rst=1; X=0;
    #10; rst=0; X=1;
    #40; X=0;
    #20; X=1;
    #10 rst=1;
    #10 rst=0;
    #20 $finish;
end
endmodule

endmodule

