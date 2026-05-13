module UART_pv (input KEY0, SW1, SW0, output logic tx_busy, rx_ready, rx, output logic [6:0] HexSeg1, HexSeg0);
logic baud_tick;
logic [7:0] tx_data, rx_data, Mostsigdig, Leastsigdig;
assign Mostsigdig = rx_data>>8'd4;
assign Leastsigdig = rx_data - (Mostsigdig<<8'd4);
assign tx_data = (SW1 == 1'b1)? 8'h90 : 8'h12;
BAUD_rate_gen B1 (KEY0, SW0, baud_tick);
UART_tx T1 (KEY0, SW0, baud_tick, 1'b1, tx_data, rx, tx_busy);
UART_rx R1 (KEY0, SW0, rx, baud_tick, rx_data, rx_ready);
Dec27Seg D1 (Mostsigdig, HexSeg1);
Dec27Seg D0 (Leastsigdig, HexSeg0);
endmodule
