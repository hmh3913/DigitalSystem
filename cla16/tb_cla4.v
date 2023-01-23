
module tb_cla4;
reg [3:0] a;
reg [3:0] b;
reg ci;
wire [3:0] S;
wire Co;
wire PG;
wire GG;

initial begin
a = 4'b0000;
b = 4'b0000;
ci = 0;
#200;
a = 4'b1100;
b = 4'b0100;
#200;
a = 4'b1100;
b = 4'b0011;
#200;
a = 4'b1011;
b = 4'b1001;
$stop;
end
//i[3:0] a, input [3:0] b, input ci, output [3:0] S, output Co, output GG, output PG
cla4 dut(a, b, ci, S, Co, GG, PG);
endmodule
