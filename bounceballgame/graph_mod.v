module graph_mod (clk, rst, x, y, key, key_pulse, rgb);
    input clk, rst;
    input [9:0] x, y;
    input [4:0] key, key_pulse; 
    output [2:0] rgb; 

    // 화면 크기 설정
    parameter MAX_X = 640; 
    parameter MAX_Y = 480;  
    //body 의 좌표 설정
    parameter BODY_Y_T = 450; 
    parameter BODY_Y_B = 480;
    //ball 속도, ball size 
    parameter BALL_SIZE = 8; 
    parameter BALL_Vx = 4;
    parameter BALL_Vy = 13; //ball의 속도
    parameter BALL_A = 1; //ball의 가속도
//----------------------------------------------    
    parameter BAR_SIZE = 20;
    parameter bar_x_reg = 50;
    parameter bar_y_reg = 200;
//----------------------------------------------
    parameter bar_x_reg_2 = 100;
    parameter bar_y_reg_2 = 300;
//----------------------------------------------
    parameter bar_x_reg_3 = 200;
    parameter bar_y_reg_3 = 250;
//----------------------------------------------
    parameter bar_x_reg_4 = 30;
    parameter bar_y_reg_4 = 100;
//----------------------------------------------
    parameter bar_x_reg_5 = 455;
    parameter bar_y_reg_5 = 165;
//----------------------------------------------
    parameter gall_x_reg = 400;
    parameter gall_y_reg = 300;
        
    wire frame_tick; 
    
    wire body_on, bar_on, bar_on_2, bar_on_3, bar_on_4, bar_on_5, ball_on ,gall_on; 
    wire [9:0] bar_y_t, bar_y_b, bar_x_l, bar_x_r;
    wire [9:0] bar_y_t_2, bar_y_b_2, bar_x_l_2, bar_x_r_2;
    wire [9:0] bar_y_t_3, bar_y_b_3, bar_x_l_3, bar_x_r_3;
    wire [9:0] bar_y_t_4, bar_y_b_4, bar_x_l_4, bar_x_r_4;
    wire [9:0] bar_y_t_5, bar_y_b_5, bar_x_l_5, bar_x_r_5;

    reg [9:0] ball_x_reg, ball_y_reg, ball_y_set;
    reg [9:0]  ball_vx_reg, ball_vy_reg; 
    wire [9:0] ball_x_l, ball_x_r, ball_y_t, ball_y_b;
    wire [9:0] gall_x_l, gall_x_r, gall_y_t, gall_y_b;
    
    wire reach_top, reach_bottom, reach_flag_out, reach_body_out, dead_flag_out, gall_on1, gall_on2;
    wire trig1, trig2, trig3;
    wire blife1, blife2;
    reg game_stop, game_over, reach_flag_in, reach_body_in, dead_flag_in_1, dead_flag_in_2, gall_set;
    
    assign frame_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // 매 프레임마다 한 clk 동안만 1이 됨. 

    assign ball_x_l = ball_x_reg; //ball의 left
    assign ball_x_r = ball_x_reg + BALL_SIZE - 1; //ball의 right
    assign ball_y_t = ball_y_reg; //ball의 top
    assign ball_y_b = ball_y_reg + BALL_SIZE; //ball의 bottom

    assign bar_x_l = bar_x_reg;
    assign bar_x_r = bar_x_reg + 70;
    assign bar_y_t = bar_y_reg;
    assign bar_y_b = bar_y_reg + BAR_SIZE;

    assign bar_x_l_2 = bar_x_reg_2;
    assign bar_x_r_2 = bar_x_reg_2 + 70;
    assign bar_y_t_2 = bar_y_reg_2;
    assign bar_y_b_2 = bar_y_reg_2 + BAR_SIZE;

    assign bar_x_l_3 = bar_x_reg_3;
    assign bar_x_r_3 = bar_x_reg_3 + 150;
    assign bar_y_t_3 = bar_y_reg_3;
    assign bar_y_b_3 = bar_y_reg_3 + BAR_SIZE;

    assign bar_x_l_4 = bar_x_reg_4;
    assign bar_x_r_4 = bar_x_reg_4 + 70;
    assign bar_y_t_4 = bar_y_reg_4;
    assign bar_y_b_4 = bar_y_reg_4 + BAR_SIZE;
    
    assign bar_x_l_5 = bar_x_reg_5;
    assign bar_x_r_5 = bar_x_reg_5 + 100;
    assign bar_y_t_5 = bar_y_reg_5;
    assign bar_y_b_5 = bar_y_reg_5 + BAR_SIZE;
    
    assign gall_x_l = gall_x_reg;
    assign gall_x_r = gall_x_reg + 30;
    assign gall_y_t = gall_y_reg;
    assign gall_y_b = gall_y_reg + 30;
   
        
    assign body_on = (y <= BODY_Y_B && y >= BODY_Y_T)? 1 : 0; // body이 있는 영역
    assign ball_on = ((x >= ball_x_l && x <= ball_x_r && y >= ball_y_t && y <= ball_y_b) &&
     (~(reach_body_in != reach_body_out)))? 1 : 0; //ball이 있는 영역
    assign bar_on = (x >= bar_x_l && x <= bar_x_r && y >= bar_y_t && y <= bar_y_b)? 1 : 0;
    assign bar_on_2 = (x >= bar_x_l_2 && x <= bar_x_r_2 && y >= bar_y_t_2 && y <= bar_y_b_2)? 1 : 0;
    assign bar_on_3 = (x >= bar_x_l_3 && x <= bar_x_r_3 && y >= bar_y_t_3 && y <= bar_y_b_3)? 1 : 0;
    assign bar_on_4 = (x >= bar_x_l_4 && x <= bar_x_r_4 && y >= bar_y_t_4 && y <= bar_y_b_4)? 1 : 0;
    assign bar_on_5 = (x >= bar_x_l_5 && x <= bar_x_r_5 && y >= bar_y_t_5 && y <= bar_y_b_5)? 1 : 0;
    assign gall_on = (x >= gall_x_l && x <= gall_x_r && y >= gall_y_t && y <= gall_y_b)? 1 : 0;

    always @ (posedge clk or posedge rst) begin
        if(rst | game_stop) begin
            ball_x_reg <= MAX_X/2; // game이 멈추면 중간에서 시작
            ball_y_reg <= MAX_Y/2;
            ball_vy_reg <= 1;
            gall_set <= 0;
        end 
        else begin           
            if (frame_tick) begin
                ball_y_reg <= ball_y_reg + ball_vy_reg; // 공 높이 
                ball_vy_reg <= ball_vy_reg + BALL_A; // 가속도에 따른 공 속도
                if (key==5'h14) ball_x_reg <= ball_x_reg + BALL_Vx; //move down
                else if (key==5'h16) ball_x_reg <= ball_x_reg - BALL_Vx;  //move up 
                else if (key == 5'h15) ball_x_reg <= MAX_X / 2;      
            end
            if(reach_flag_in != reach_flag_out || reach_body_in != trig1 || reach_body_in != trig2 || reach_body_in != trig3) begin
                ball_vy_reg <= -1 * BALL_Vy;
            end
            if(ball_x_r >= gall_x_l && ball_x_l <= gall_x_r && ball_y_b >= gall_y_t && ball_y_t <= gall_y_b) 
                gall_set <= 1;

        end            
    end
    attacked #(.BALL_SIZE(BALL_SIZE), .BODY_SIZE(30)) reach_body(clk, rst, reach_flag_in, ball_x_reg, ball_y_reg, 0, BODY_Y_T, 640, reach_flag_out);
    attacked #(.BALL_SIZE(BALL_SIZE), .BODY_SIZE(BAR_SIZE)) reach_bar(clk, rst, reach_body_in, ball_x_reg, ball_y_reg, bar_x_reg, bar_y_reg, 70, trig1);
    attacked #(.BALL_SIZE(BALL_SIZE), .BODY_SIZE(BAR_SIZE)) dead_bar(clk, rst, dead_flag_in_1, ball_x_reg, ball_y_reg, bar_x_reg_2, bar_y_reg_2, 70, blife1);
    attacked #(.BALL_SIZE(BALL_SIZE), .BODY_SIZE(BAR_SIZE)) reach_bar2(clk, rst, reach_body_in, ball_x_reg, ball_y_reg, bar_x_reg_3, bar_y_reg_3, 150, trig2);
    attacked #(.BALL_SIZE(BALL_SIZE), .BODY_SIZE(BAR_SIZE)) dead_bar2(clk, rst, dead_flag_in_2, ball_x_reg, ball_y_reg, bar_x_reg_4, bar_y_reg_4, 70, blife2);
    attacked #(.BALL_SIZE(BALL_SIZE), .BODY_SIZE(BAR_SIZE)) reach_bar3(clk, rst, reach_body_in, ball_x_reg, ball_y_reg, bar_x_reg_5, bar_y_reg_5, 100, trig3);
   
/*---------------------------------------------------------*/
// finite state machine for game control
/*---------------------------------------------------------*/
parameter NEWGAME = 2'b00, PLAY = 2'b01, NEWBALL = 2'B10, OVER = 2'B11;
reg [1:0] state_reg, state_next;
reg [1:0] life_reg, life_next;

always @* begin 
    game_stop = 1;
    life_next = life_reg;
    game_over = 0;
    case(state_reg)
        NEWGAME: begin
            if(key[4] == 1) begin
                state_next = PLAY;
                life_next = 2'b10;
            end else begin
                state_next = NEWGAME;
                life_next = 2'b11;
            end
        end    
        PLAY: begin
            game_stop = 0;
            if(dead_flag_in_1 != blife1 || dead_flag_in_2 != blife2) begin
                if(life_reg == 2'b00) begin
                    state_next = OVER;
                end
                else begin
                    state_next = NEWBALL;
                    life_next = life_reg - 1'b1;
                end 
            end
            else state_next = PLAY;
        end
        NEWBALL:begin
            dead_flag_in_1 = blife1; 
            dead_flag_in_2 = blife2;
            if(key[4] == 1) state_next = PLAY;
            else state_next = NEWBALL; 
        end
            
        OVER: begin
            dead_flag_in_1 = blife1;
            dead_flag_in_2 = blife2;
            if(key[4] == 1) begin
                state_next = NEWGAME;
            end 
            else begin
                state_next = OVER;
            end
            game_over = 1;        
        end
        default:
            state_next = NEWGAME;         
    endcase              
end

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        state_reg <= NEWGAME; 
        life_reg <= 0;
    end else begin
        state_reg <= state_next; 
        life_reg <= life_next;
    end
end

/*---------------------------------------------------------*/
// text on screen 
/*---------------------------------------------------------*/
// score region
wire [6:0] char_addr;
reg [6:0] char_addr_s, char_addr_l, char_addr_o, char_addr_w;
wire [2:0] bit_addr, score_set;
reg [2:0] bit_addr_s, bit_addr_l, bit_addr_o, bit_addr_w;
wire [3:0] row_addr, row_addr_s, row_addr_l, row_addr_o, row_addr_w ; 
wire score_on, life_on, over_on, win_on;

wire font_bit;
wire [7:0] font_word;
wire [10:0] rom_addr;

font_rom_vhd font_rom_inst (clk, rom_addr, font_word);

assign score_set = gall_set;
assign rom_addr = {char_addr, row_addr};
assign font_bit = font_word[~bit_addr]; //화면 x좌표는 왼쪽이 작은데, rom의 bit는 오른쪽이 작으므로 reverse

assign char_addr = (score_on)? char_addr_s : (life_on)? char_addr_l : (over_on)? char_addr_o : (win_on)? char_addr_w : 0;
assign row_addr = (score_on)? row_addr_s : (life_on)? row_addr_l : (over_on)? row_addr_o : (win_on)? row_addr_w : 0; 
assign bit_addr = (score_on)? bit_addr_s : (life_on)? bit_addr_l : (over_on)? bit_addr_o : (win_on)? bit_addr_w : 0; 

// score
wire [9:0] score_x_l, score_y_t;
assign score_x_l = 100; 
assign score_y_t = 0; 
assign score_on = (y>=score_y_t && y<score_y_t+16 && x>=score_x_l && x<score_x_l+8*4)? 1 : 0; 
assign row_addr_s = y-score_y_t;
always @ (*) begin
    if (x>=score_x_l+8*0 && x<score_x_l+8*1) begin bit_addr_s = x-score_x_l-8*0; char_addr_s = 7'b1010011; end // S x53    
    else if (x>=score_x_l+8*1 && x<score_x_l+8*2) begin bit_addr_s = x-score_x_l-8*1; char_addr_s = 7'b0111010; end // : x3a
    else if (x>=score_x_l+8*3 && x<score_x_l+8*4) begin bit_addr_s = x-score_x_l-8*3; char_addr_s = {3'b0110, score_set}; end // digit 1
    else begin bit_addr_s = 0; char_addr_s = 0; end                         
end

//remaining ball
wire [9:0] life_x_l, life_y_t; 
assign life_x_l = 200; 
assign life_y_t = 0; 
assign life_on = (y>=life_y_t && y<life_y_t+16 && x>=life_x_l && x<life_x_l+8*3)? 1 : 0;
assign row_addr_l = y-life_y_t;
always @(*) begin
    if (x>=life_x_l+8*0 && x<life_x_l+8*1) begin bit_addr_l = (x-life_x_l-8*0); char_addr_l = 7'b1000010; end // B x42  
    else if (x>=life_x_l+8*1 && x<life_x_l+8*2) begin bit_addr_l = (x-life_x_l-8*1); char_addr_l = 7'b0111010; end // :
    else if (x>=life_x_l+8*2 && x<life_x_l+8*3) begin bit_addr_l = (x-life_x_l-8*2); char_addr_l = {5'b01100, life_reg}; end
    else begin bit_addr_l = 0; char_addr_l = 0; end   
end

// game over
assign over_on = (game_over==1 && y[9:6]==3 && x[9:5]>=5 && x[9:5]<=13)? 1 : 0;
assign win_on = (bar_x_l_5<=ball_x_reg && bar_x_r_5>=ball_x_reg && ball_y_reg<=bar_y_t_5 && y[9:6]==3 && x[9:5]>=5 && x[9:5]<=13)? 1 : 0;
assign row_addr_o = y[5:2];
assign row_addr_w = y[5:2];
always @(*) begin
    bit_addr_o = x[4:2];
    case (x[9:5]) 
        5: char_addr_o = 7'b1000111; // G x47
        6: char_addr_o = 7'b1100001; // a x61
        7: char_addr_o = 7'b1101101; // m x6d
        8: char_addr_o = 7'b1100101; // e x65
        9: char_addr_o = 7'b0000000; //                      
        10: char_addr_o = 7'b1001111; // O x4f
        11: char_addr_o = 7'b1110110; // v x76
        12: char_addr_o = 7'b1100101; // e x65
        13: char_addr_o = 7'b1110010; // r x72
        default: char_addr_o = 0; 
    endcase
end

always @(*) begin
    bit_addr_w = x[4:2];
    case (x[9:5]) 
        5: char_addr_w = 7'b0000000; // 
        6: char_addr_w = 7'b1011001; // Y x59
        7: char_addr_w = 7'b1101111; // o x6f
        8: char_addr_w = 7'b1110101; // u x75
        9: char_addr_w = 7'b0000000; //                      
        10: char_addr_w = 7'b1010111; // W x57
        11: char_addr_w = 7'b1101111; // o x6f
        12: char_addr_w = 7'b1101110; // n x6e
        13: char_addr_w = 7'b0000010; // ^^
        default: char_addr_w = 0; 
    endcase
end

    assign rgb = (font_bit & score_on)? 3'b010:
            (font_bit & life_on)? 3'b010:
            (font_bit & over_on)? 3'b010:
            (font_bit & win_on)? 3'b010:
            (bar_on | bar_on_3 | bar_on_5)? 3'b000 :    //white bar
            (body_on)? 3'b000 :
  
            (ball_on)? 3'b100 :
            (gall_on)? 3'b110 :
            (bar_on_2 | bar_on_4)? 3'b100 : // dead bar red
             3'b111 ;             
endmodule