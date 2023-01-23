module tb_tx;
reg clk, rst ,uart_tx_en, uart_rxd;
reg [7:0] uart_tx_data;
wire[7:0] uart_rx_data;
wire tx_busy, rx_busy;
wire uart_txd;

initial begin
clk = 0; rst = 1; uart_tx_en = 0; uart_rxd = 0;
uart_tx_data = 00010001;
#15; rst = 0;
#10; uart_tx_en = 1;
#15; uart_tx_en = 0;
end

always begin
#10; clk = ~clk; uart_rxd = uart_txd;
end

uart_tx dut1(clk, rst, uart_tx_en, uart_tx_data, tx_busy, uart_txd);
uart_rx dut2(clk, rst, uart_rxd, rx_busy , uart_rx_data);
endmodule
