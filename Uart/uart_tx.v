module uart_tx (
    input clk,
    input rst,	
    input uart_tx_en, 	    //전송 버튼,debouncer입력으로
    input [7:0] uart_tx_data, //송신할 8비트 data 
    output reg tx_busy,	    //idle 상태가 아닐때 '1'
    output reg uart_txd 	    //송신 데이터
);
wire uart_start_pulse;
reg [3:0] state;
reg [3:0] next;
reg [10:0] o;
parameter IDLE=4'b0000, START=4'b0001, BIT0=4'b0010, 
BIT1=4'b0011, BIT2=4'b0100, BIT3=4'b0101, BIT4=4'b0110, 
BIT5=4'b0111, BIT6=4'b1000, BIT7=4'b1001, STOP=4'b1010;

always@(*)begin
    case(state)
        IDLE : begin tx_busy = 1'b0; uart_txd = 1'b1; next = IDLE; end           
        START : begin tx_busy = 1'b1; uart_txd = 1'b0; next = BIT0; end
        BIT0 : begin tx_busy = 1'b1; uart_txd = uart_tx_data[0]; next = BIT1; end
        BIT1 : begin tx_busy = 1'b1; uart_txd = uart_tx_data[1]; next = BIT2; end
        BIT2 : begin tx_busy = 1'b1; uart_txd = uart_tx_data[2]; next = BIT3; end
        BIT3 : begin tx_busy = 1'b1; uart_txd = uart_tx_data[3]; next = BIT4; end
        BIT4 : begin tx_busy = 1'b1; uart_txd = uart_tx_data[4]; next = BIT5; end
        BIT5 : begin tx_busy = 1'b1; uart_txd = uart_tx_data[5]; next = BIT6; end
        BIT6 : begin tx_busy = 1'b1; uart_txd = uart_tx_data[6]; next = BIT7; end
        BIT7 : begin tx_busy = 1'b1; uart_txd = uart_tx_data[7]; next = STOP; end
        STOP : begin tx_busy = 1'b1; uart_txd = 1'b1; next = IDLE; end
        default : begin tx_busy = 1'b1; uart_txd = 1'b1; next = IDLE; end
    endcase
end

always@(posedge clk or posedge rst) begin
    if (rst) begin state <= IDLE; end
    else if(uart_start_pulse) state <= START;
    else if(o == 868) begin state <= next; end
end

always@(posedge clk or posedge rst) begin
    if (rst) o <= 0;
    else if(tx_busy) begin
        if(o == 868) o <= 0;
        else o <= o + 1;
    end
end

 // assign uart_start_pulse = uart_tx_en; //for simulation
 debounce debounce_inst (clk, rst, uart_tx_en, , uart_start_pulse); //for kit
endmodule