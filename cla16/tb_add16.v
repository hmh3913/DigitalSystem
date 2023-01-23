module tb_add16;
reg [15:0] a;
reg [15:0] b;
reg ci = 0;
wire [15:0] S, s;
wire Co;
wire co;
wire GGo;
wire PGo;

initial begin
a = 16'b0000_1100_0010_1000;
b = 16'b0100_1100_1011_1010;
#200;
a = 16'b0000_0000_1010_1000;
b = 16'b0100_1100_1010_1010;
#200;
a = 16'b1100_1100_0010_1000;
b = 16'b0100_1100_1010_1000;
#200;
a = 16'b0110_0100_0110_1111;
b = 16'b0100_1100_1000_1000;
#200;
a = 16'b1101_1100_0010_1000;
b = 16'b1100_1100_1010_1000;
$stop;
end
//module add16(input [15:0] a, input [15:0] b, input ci, output [15:0] s, output co);
add16 dut1(a, b, ci, s, co); 
cla16 dut2(a, b, ci, S, Co, GGo, PGo);

endmodule

