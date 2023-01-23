module avoid_ball(clk, rst, x, y, key, game_stop, en, avoid_ball_x_l, avoid_ball_x_r, avoid_ball_y_t, avoid_ball_y_b);

input clk, rst;
input [9:0] x, y;
input [4:0] key; 
input game_stop;
input en;
output [9:0] avoid_ball_x_l, avoid_ball_x_r, avoid_ball_y_t, avoid_ball_y_b;

// ȭ�� ũ�� ����
parameter MAX_X = 640; 
parameter MAX_Y = 480;  
parameter HALF_X = 320;
parameter HALF_Y = 240;
//ball �ӵ�, ball size 
parameter BALL_SIZE = 20; 
parameter BALL_V = 4; //ball�� �ӵ�
// ȭ�� ���� 
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
assign frame_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // �� �����Ӹ��� �� clk ���ȸ� 1�� ��. 

assign avoid_ball_x_l = avoid_ball_x_reg; //ball�� left
assign avoid_ball_x_r = avoid_ball_x_reg + BALL_SIZE - 1; //ball�� right
assign avoid_ball_y_t = avoid_ball_y_reg; //ball�� top
assign avoid_ball_y_b = avoid_ball_y_reg + BALL_SIZE - 1; //ball�� bottom

always @ (posedge clk or posedge rst) begin
    if(rst | game_stop) begin
        avoid_ball_x_reg <= HALF_X; // game�� ���߸� �߰����� ����
        avoid_ball_y_reg <= HALF_Y; // game�� ���߸� �߰����� ����
    end else if (frame_tick && en) begin
        avoid_ball_x_reg <= avoid_ball_x_reg + avoid_ball_vx_reg; //�� �����Ӹ��� ball_vx_reg��ŭ ������
        avoid_ball_y_reg <= avoid_ball_y_reg + avoid_ball_vy_reg; //�� �����Ӹ��� ball_vy_reg��ŭ ������
    end
end

assign reach_top = (avoid_ball_y_t==MIN_Y)? 1 : 0; //ball ���� ��谡 1���� ������ õ�忡 �ε���
assign reach_bottom = (avoid_ball_y_b>MAX_Y-1)? 1 : 0; //ball�� �Ʒ��� ��谡 479���� ũ�� �ٴڿ� �ε���
assign reach_left = (avoid_ball_x_l<=MIN_X)? 1 : 0; //ball�� ���� ��谡 ���� ��ǥ�� �� ���� ������ �ε���
assign reach_right = (avoid_ball_x_r>=MAX_X)? 1 : 0; //ball�� ������ ��谡 ������ ��ǥ�� �� ���� ũ��  �ε���


always @ (posedge clk or posedge rst) begin
    if(rst | game_stop) begin
        avoid_ball_vx_reg <= BALL_V*BALL_X_D; //game�� ���߸� ������ 
        avoid_ball_vy_reg <= BALL_V*BALL_Y_D; //game�� ���߸� �Ʒ���
    end else begin
        if (reach_top) avoid_ball_vy_reg <= BALL_V; //õ�忡 �ε����� �Ʒ���.
        else if (reach_bottom) avoid_ball_vy_reg <= -1*BALL_V; //�ٴڿ� �ε����� ����
        else if (reach_left) avoid_ball_vx_reg <= BALL_V; //left ��  �ε����� ���������� 
        else if (reach_right) avoid_ball_vx_reg <= -1*BALL_V; //right �� ƨ��� ��������
        
    end  
end


endmodule
