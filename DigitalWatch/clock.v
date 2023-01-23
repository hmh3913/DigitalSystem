module clock(clk_6mhz, rst, clock_en, digit, up, down, sec0, sec1, min0, min1, hrs0, hrs1);
input clk_6mhz, rst, clock_en, up, down;
input [5:0] digit;
output [3:0] sec0, sec1, min0, min1, hrs0, hrs1;
reg [3:0] sec0, sec1, min0, min1, hrs0, hrs1;
wire trigger1, trigger2, trigger3, trigger4, trigger5, trigger6;

always@(posedge clk_6mhz or posedge rst) begin
    if(rst) sec0 <= 4'b0;
    else if(digit[5] == 1'b1 && up == 1'b1) sec0 <= sec0 + 1;
    else if(digit[5] == 1'b1 && down == 1'b1) sec0 <= sec0 -1;
    else if(clock_en)
        if(sec0 == 9) begin sec0 <= 0; end
        else begin sec0 <= sec0 + 1; end 
    end
assign trigger1 = (sec0 == 9) ? 1'b1 : 1'b0;
 
always@(posedge clk_6mhz or posedge rst) begin
    if(rst) sec1 <= 4'b0;
    else if(digit[4] == 1'b1 && up == 1'b1) sec1 <= sec1 + 1;
    else if(digit[4] == 1'b1 && down == 1'b1) sec1 <= sec1 - 1;
    else if(trigger1 && clock_en)
        if(sec1 == 5) begin sec1 <= 0; end
        else begin sec1 <= sec1 + 1; end
    end 
 assign trigger2 = (sec1 == 5 && sec0== 9 && clock_en) ? 1'b1 : 1'b0;
    
 always@(posedge clk_6mhz or posedge rst) begin
    if(rst) min0 <= 4'b0;
    else if(digit[3] == 1'b1 && up == 1'b1) min0 <= min0 + 1;
    else if(digit[3] == 1'b1 && down == 1'b1) min0 <= min0 - 1;
    else if(trigger2 && clock_en)
        if(min0 == 9) begin min0 <= 0;end
        else begin min0 <= min0 + 1; end
    end
 assign trigger3 = (min0 == 9 && sec1 == 5 && sec0== 9 && clock_en) ? 1'b1 : 1'b0;
  
always@(posedge clk_6mhz or posedge rst) begin
    if(rst) min1 <= 4'b0;
    else if(digit[2] == 1'b1 && up == 1'b1) min1 <= min1 + 1;
    else if(digit[2] == 1'b1 && down == 1'b1) min1 <= min1 - 1;
    else if(trigger3 && clock_en)
        if(min1 == 5) begin min1 <= 0; end
        else begin min1 <= min1 + 1; end
    end
assign trigger4 = (min1 == 5 && min0 == 9 && sec1 == 5 && sec0== 9 && clock_en) ? 1'b1 : 1'b0;
   
always@(posedge clk_6mhz or posedge rst) begin
    if(rst) hrs0 <= 4'b0;
    else if(digit[1] == 1'b1 && up == 1'b1) hrs0 <= hrs0 + 1;
    else if(digit[1] == 1'b1 && down == 1'b1) hrs0 <= hrs0 - 1;
    else if(trigger6 && clock_en) begin hrs0 <= 0;
    end
    else if(trigger4 && clock_en)
        if(hrs0 == 10) begin hrs0 <= 0; end
        else begin hrs0 <= hrs0 + 1; end
 end
assign trigger5 = (hrs0 == 9 && min1 == 5 && min0 == 9 && sec1 == 5 && sec0== 9) ? 1'b1 : 1'b0;
assign trigger6 = (hrs1 == 2 && hrs0 == 3 && min1 == 5 && min0 == 9 && sec1 == 5 && sec0== 9) ? 1'b1 : 1'b0;

always@(posedge clk_6mhz or posedge rst) begin
    if(rst) hrs1 <= 4'b0;
    else if(digit[0] == 1'b1 && up == 1'b1) hrs1 <= hrs1 + 1;
    else if(digit[0] == 1'b1 && down == 1'b1) hrs1 <= hrs1 - 1;
    else if(trigger5 && clock_en)
        if(hrs1 == 2) begin hrs1 <= 0; end
        else begin hrs1 <= hrs1 + 1; end
    else if(trigger6 && clock_en) hrs1 <= 0;
 end

endmodule