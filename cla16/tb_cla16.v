//module cla16(input [15:0] a, input [15:0] b, input ci, output [15:0] S, output Co, output GGo, output PGo);
//wire [3:0] GG;
//wire [3:0] PG;
//wire [3:1] C;

module tb_cla16;
reg [15:0] a;
reg [15:0] b;
reg ci;
wire [15:0] S;
wire Co;
wire GGo;
wire PGo;

initial begin
a = 16'b0000_1100_0010_1000;
b = 16'b0100_1100_1011_1010;
ci = 0;
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
//module cla16(input [15:0] a, input [15:0] b, input ci, output [15:0] S, output Co, output GGo, output PGo);
cla16 dut(a, b, ci, S, Co, GGo, PGo);
endmodule