module avoid_ball(clk, rst, x, y, key, game_stop, en, avoid_ball_x_l, avoid_ball_x_r, avoid_ball_y_t, avoid_ball_y_b);

input clk, rst;
input [9:0] x, y;
input [4:0] key; 
input game_stop;
input en;
output [9:0] avoid_ball_x_l, avoid_ball_x_r, avoid_ball_y_t, avoid_ball_y_b;

// 화면 크기 설정
parameter MAX_X = 640; 
parameter MAX_Y = 480;  
parameter HALF_X = 320;
parameter HALF_Y = 240;
//ball 속도, ball size 
parameter BALL_SIZE = 20; 
parameter BALL_V = 4; //ball의 속도
// 화면 원점 
parameter MIN_X = 0;
parameter MIN_Y = 0;
parameter BALL_X_D = 1;
parameter BALL_Y_D = 1;
wire frame_tick; 
wire avoid_ball_on;
reg [9:0] avoid_ball_x_reg, avoid_ball_y_reg;
reg [9:0] avoid_ball_vx_reg, avoid_ball_vy_reg; 
wire [9:0] avoid_ball_x_l, avoid_ball_x_r, avoid_ball_y_t,avoid_ball_y_b;
wire reach_top, reach_bottom, reach_left, reach_right, reach_bar, miss_ball, x_touch, y_touch, touch_ball;
reg  game_over;  

//refrernce tick 
assign frame_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // 매 프레임마다 한 clk 동안만 1이 됨. 

assign avoid_ball_x_l = avoid_ball_x_reg; //ball의 left
assign avoid_ball_x_r = avoid_ball_x_reg + BALL_SIZE - 1; //ball의 right
assign avoid_ball_y_t = avoid_ball_y_reg; //ball의 top
assign avoid_ball_y_b = avoid_ball_y_reg + BALL_SIZE - 1; //ball의 bottom

always @ (posedge clk or posedge rst) begin
    if(rst | game_stop) begin
        avoid_ball_x_reg <= HALF_X; // game이 멈추면 중간에서 시작
        avoid_ball_y_reg <= HALF_Y; // game이 멈추면 중간에서 시작
    end else if (frame_tick && en) begin
        avoid_ball_x_reg <= avoid_ball_x_reg + avoid_ball_vx_reg; //매 프레임마다 ball_vx_reg만큼 움직임
        avoid_ball_y_reg <= avoid_ball_y_reg + avoid_ball_vy_reg; //매 프레임마다 ball_vy_reg만큼 움직임
    end
end

assign reach_top = (avoid_ball_y_t==MIN_Y)? 1 : 0; //ball 윗쪽 경계가 1보다 작으면 천장에 부딪힘
assign reach_bottom = (avoid_ball_y_b>MAX_Y-1)? 1 : 0; //ball의 아래쪽 경계가 479보다 크면 바닥에 부딪힘
assign reach_left = (avoid_ball_x_l<=MIN_X)? 1 : 0; //ball의 왼쪽 경계가 왼쪽 좌표의 끝 보다 작으면 부딪힘
assign reach_right = (avoid_ball_x_r>=MAX_X)? 1 : 0; //ball의 오른쪽 경계가 오른쪽 좌표의 끝 보다 크면  부딪힘


always @ (posedge clk or posedge rst) begin
    if(rst | game_stop) begin
        avoid_ball_vx_reg <= BALL_V*BALL_X_D; //game이 멈추면 오른쪽 
        avoid_ball_vy_reg <= BALL_V*BALL_Y_D; //game이 멈추면 아래로
    end else begin
        if (reach_top) avoid_ball_vy_reg <= BALL_V; //천장에 부딪히면 아래로.
        else if (reach_bottom) avoid_ball_vy_reg <= -1*BALL_V; //바닥에 부딪히면 위로
        else if (reach_left) avoid_ball_vx_reg <= BALL_V; //left 벽  부딪히면 오른쪽으로 
        else if (reach_right) avoid_ball_vx_reg <= -1*BALL_V; //right 벽 튕기면 왼쪽으로
        
    end  
end


endmodule
