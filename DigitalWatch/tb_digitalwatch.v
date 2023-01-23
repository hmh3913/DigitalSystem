
module tb_digitalwatch;
reg clk, reset_poweron;
reg clk_6mhz;
wire counter_en;
reg clock_en;
reg [3:0] btn;
reg rst, up, down;
reg [5:0] digit;
wire [3:0] sec0, sec1, min0, min1, hrs0, hrs1;
wire [7:0] seg_data;
wire [5:0] seg_com;

initial begin
    clk = 0; clock_en = 0; reset_poweron = 1; btn = 0; rst = 1; digit = 6'b101010; up = 0; down = 0;
    #1 rst = 0; reset_poweron = 0;
    #100 btn = 4'b0010; up = 1; down = 0;
    #25 btn = 4'b0000; up = 0; down = 0;
    #100 btn = 4'b0010; up = 1; down = 0;
    #25 btn = 4'b0000; up = 0; down = 0;
    #100 btn = 4'b0001; up = 0; down = 1;
    #25 btn = 4'b0000; up = 0; down = 0;
    #100 btn = 4'b0001; up = 0; down = 1;
    #25 btn = 4'b0000; up = 0; down = 0;
end

always begin
    #10; clk = ~clk; clk_6mhz = clk; clock_en = counter_en;

end

top u1(clk, reset_poweron, btn, seg_data, seg_com);
clock u2(clk_6mhz, rst, clock_en, digit, up, down, sec0, sec1, min0, min1, hrs0, hrs1);
gen_counter_en #(.SIZE(10)) u3(clk, rst, counter_en);


endmodule
