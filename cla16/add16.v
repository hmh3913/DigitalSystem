
module add16(input [15:0] a, input [15:0] b, input ci, output [15:0] s, output co);
    wire	[3:1]	c;
    //module add4(input [3:0] a, input [3:0] b, input ci, output [3:0] s, output co);   
    add4 u0(a[3:0], b[3:0], ci, s[3:0], c[1]); 
    add4 u1(a[7:4], b[7:4], c[1], s[7:4], c[2]); 
    add4 u2(a[11:8], b[11:8], c[2], s[11:8], c[3]); 
    add4 u3(a[15:12], b[15:12], c[3], s[15:12], co);
    
endmodule
