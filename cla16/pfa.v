module pfa(input a, input b, input ci, output p, output g, output s);


assign p = a ^ b;
assign g = a & b;
assign s = a ^ b ^ ci;

endmodule