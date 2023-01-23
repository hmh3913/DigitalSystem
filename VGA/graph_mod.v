module graph_mod (clk, rst, x, y, key, key_pulse, rgb);
input clk, rst;
input [9:0] x, y;
input [4:0] key, key_pulse; 
output [2:0] rgb; 
reg [9:0] a;
wire [9:0] bar_y_t, bar_y_b;
wire trig;
reg b;

always@(posedge clk or posedge rst) begin
    if(rst) a<= 0;
    else if(trig == 1 && b == 0) a <= a+4;
    else if(trig == 1 && b == 1) a <= a-4;
    else if(a == 479) a <= 0;
end
always@(posedge clk or posedge rst) begin
    if(rst) b <=0;
    else if(a == 0) b <= 0;
    else if(a == 479) b <= 1;
end
assign trig = (x== 639 && y == 479)? 1:0;
assign bar_y_t = a;
assign bar_y_b = bar_y_t + 71;


assign rgb = (x>=600 && x<=603 && y>=bar_y_t && y<=bar_y_b)? 3'b010 : 3'b110;

endmodule
