
//module pfa(input a, input b, input ci, output p, output g, output s);g);
//module cla_logic(input ci, input [3:0] p, input [3:0] g, output [4:1] C, output PG, output GG, output Co);
module cla4(input [3:0] a, input [3:0] b, input ci, output [3:0] S, output Co, output GG, output PG);
wire [3:0] g;
wire [3:0] p;
wire [3:1] C;

cla_logic cla0 (ci, p, g, C, PG, GG, Co);
pfa f0 (a[0], b[0], ci, p[0], g[0], S[0]);
pfa f1 (a[1], b[1], C[1], p[1], g[1], S[1]);
pfa f2 (a[2], b[2], C[2], p[2], g[2], S[2]);
pfa f3 (a[3], b[3], C[3], p[3], g[3], S[3]);

endmodule
