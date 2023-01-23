
module cla16(input [15:0] a, input [15:0] b, input ci, output [15:0] S, output Co, output GGo, output PGo);
wire [3:0] GG;
wire [3:0] PG;
wire [3:1] C;


cla_logic cla1 (ci, PG[3:0], GG[3:0], C[3:1], PGo, GGo, Co);
cla4 u0 (a[3:0], b[3:0], ci, S[3:0], PG[0], GG[0]);
cla4 u1 (a[7:4], b[7:4], C[1],  S[7:4], PG[1], GG[1]);
cla4 u2 (a[11:8], b[11:8], C[2], S[11:8], PG[2], GG[2]);
cla4 u3 (a[15:12], b[15:12], C[3], S[15:12], PG[3], GG[3]);

endmodule
