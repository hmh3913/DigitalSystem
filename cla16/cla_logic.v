module cla_logic(input ci, input [3:0] p, input [3:0] g, output [3:1] C, output PG, output GG, output Co);


assign C[1] = g[0] | (p[0] & ci);
assign C[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & ci);
assign C[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & ci);
assign Co = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & ci);
   
assign PG = p[3] & p[2] & p[1] & p[0];
assign GG = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule