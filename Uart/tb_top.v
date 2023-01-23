module tb_top;
reg clk, rst, uart_tx_en;
reg [7:0] uart_tx_data;
wire uart_txd;
reg uart_rxd;
wire [7:0] uart_rx_data;

initial begin
clk = 0; rst = 0; uart_tx_en = 0; uart_rxd = 0;
uart_tx_data = 8'b11001100;
#10; uart_tx_en = 1;
#15; uart_tx_en = 0;

end

always begin
#10; clk = ~clk;
end

uart_top inst1 (clk, rst, uart_tx_en, uart_tx_data, uart_txd, uart_rxd, uart_rx_data);
endmodule
