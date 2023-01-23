module uart_rx (
    input clk,
    input rst,
    input uart_rxd, 	    //수신 데이터
    output reg rx_busy,	    //idle 상태가 아닐때 '1' 
    output reg [7:0] uart_rx_data //수신한 8비트 data
);
reg [3:0] state;
reg [3:0] next;
reg [10:0] o;
reg [2:0] count;

parameter IDLE=4'b0000, START=4'b0001, BIT0=4'b0010, 
BIT1=4'b0011, BIT2=4'b0100, BIT3=4'b0101, BIT4=4'b0110, 
BIT5=4'b0111, BIT6=4'b1000, BIT7=4'b1001, STOP=4'b1010; 

always@(*) begin
    case(state)
        IDLE : begin rx_busy = 1'b0; next = IDLE; end
        START : begin rx_busy = 1'b1; next = BIT0; end
        BIT0 : begin rx_busy = 1'b1; next = BIT1; end
        BIT1 : begin rx_busy = 1'b1; next = BIT2; end
        BIT2 : begin rx_busy = 1'b1; next = BIT3; end
        BIT3 : begin rx_busy = 1'b1; next = BIT4; end
        BIT4 : begin rx_busy = 1'b1; next = BIT5; end
        BIT5 : begin rx_busy = 1'b1; next = BIT6; end
        BIT6 : begin rx_busy = 1'b1; next = BIT7; end
        BIT7 : begin rx_busy = 1'b1; next = STOP; end
        STOP : begin rx_busy = 1'b1; next = IDLE; end
        default : begin rx_busy = 1'b1; next = IDLE; end
    endcase
end

always@(posedge clk or posedge rst) begin
    if(rst) begin uart_rx_data <= 0; state <= IDLE; end
    else if(rx_busy == 1'b0 && uart_rxd == 1'b0) state <= START; 
    else if(o == 868) state <= next;
    else if(o == 434) begin
        case(state)
            BIT0 : begin uart_rx_data[0] <= uart_rxd; end
            BIT1 : begin uart_rx_data[1] <= uart_rxd; end
            BIT2 : begin uart_rx_data[2] <= uart_rxd; end
            BIT3 : begin uart_rx_data[3] <= uart_rxd; end
            BIT4 : begin uart_rx_data[4] <= uart_rxd; end
            BIT5 : begin uart_rx_data[5] <= uart_rxd; end
            BIT6 : begin uart_rx_data[6] <= uart_rxd; end
            BIT7 : begin uart_rx_data[7] <= uart_rxd; end
        endcase
    end
end

always@(posedge clk or posedge rst) begin
    if (rst) o <= 0;
    else if (rx_busy) begin
        if(o == 868) o <= 0;
        else o <= o + 1;
    end
end

endmodule