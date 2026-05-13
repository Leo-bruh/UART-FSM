//
// test bench for UART fsm transmitting 8'h12 and 8'h90
//
`timescale 1ns/1ps

module UART_tb ();
logic clk, reset, baud_tick, tx_start, tx, tx_busy, rx_ready;
logic [7:0] tx_data, rx_data ;
BAUD_rate_gen B1 (clk, reset, baud_tick);
UART_tx T1 (clk, reset, baud_tick, tx_start, tx_data, tx, tx_busy);
UART_rx R1 (clk, reset, tx, baud_tick, rx_data, rx_ready);
initial begin
	reset = 1'b1; #10;
	reset = 1'b0; clk = 1'b0; #10
	repeat (210) begin
		clk = 1'b1; #10;
		clk = 1'b0; #10;
	end
end
initial begin
	tx_start = 1'b1; tx_data = 8'h12; #100;
	tx_data = 8'h90; #1730;
	$display("rx_data = %h", rx_data);
	#2000;
	$display("rx_data = %h", rx_data);
end
endmodule
