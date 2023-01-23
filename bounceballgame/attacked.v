module attacked (clk, rst, reach_flag_in, ball_x_reg, ball_y_reg, body_x_reg, body_y_reg, body_h_size, reach_flag_out);
    parameter BALL_SIZE = 8;
    parameter BODY_SIZE = 5; 
    
    input clk, rst;
    input reach_flag_in;
    input [9:0] ball_x_reg, ball_y_reg, body_x_reg, body_y_reg, body_h_size;
    output reach_flag_out;

    wire [9:0] ball_x_l, ball_x_r, ball_y_b, ball_y_t, body_x_l, body_x_r, body_y_b, body_y_t ;
    reg reach_flag_out ;
        
    assign ball_x_l = ball_x_reg;
    assign ball_x_r = ball_x_reg + BALL_SIZE - 1;
    assign ball_y_t = ball_y_reg;
    assign ball_y_b = ball_y_reg + BALL_SIZE;

    assign body_x_l = body_x_reg;
    assign body_x_r = body_x_reg + body_h_size - 1;
    assign body_y_t = body_y_reg;
    assign body_y_b = body_y_reg + BODY_SIZE;
    
    always @(posedge clk, posedge rst) begin
        if(rst == 1)begin
            reach_flag_out <= reach_flag_in;
        end
        else if (ball_x_l>=body_x_l && ball_x_r<=body_x_r && ball_y_b <= body_y_b) begin
            if(ball_y_b >= body_y_t) reach_flag_out <= (reach_flag_in == 0)? 1 : 0 ;
            else reach_flag_out <= reach_flag_in ;
        end
    end
   
endmodule