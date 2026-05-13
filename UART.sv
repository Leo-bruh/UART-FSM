//
// returns a baud_tick = 1 when CLOCK_FREQ / BAUD_RATE clock cycles have passed
//
module BAUD_rate_gen #(parameter CLOCK_FREQ = 100, parameter BAUD_RATE = 10) (input clk, reset, output logic baud_tick);
logic [3:0] BAUD_DIV, Count, next_Count;
assign BAUD_DIV = CLOCK_FREQ / BAUD_RATE;
Dreg #(4) D1 (next_Count, reset, clk, Count);
assign next_Count = (Count<BAUD_DIV-4'b1)? Count+4'd1 : 4'd0;
assign baud_tick = (Count == reset)? 1'b1 : 1'b0;
endmodule

//
// transmits tx_data through tx one bit every baud_tick
//
module UART_tx (input clk, reset, baud_tick, tx_start, input [7:0] tx_data, output logic tx, tx_busy);
logic [1:0] State, next_State;
logic [9:0] Buffer, next_Buffer;
logic [3:0] bit_count, next_bit_count;
localparam RS = 2'b00, LD = 2'b01, TX = 2'b10;
Dreg #(2) D2 (next_State, reset, clk, State);
Dreg #(10) D3 (next_Buffer, reset, clk && (State == LD), Buffer);
Dreg #(4) D4 (next_bit_count, reset, clk, bit_count);
mux31 #(2) M1 (((tx_start == 1'b1) && (tx_busy == 1'b0))? LD : RS, (Buffer == next_Buffer)? TX : LD, ((tx_busy == 1'b0) && (baud_tick == 1'b1))? LD : TX, State, next_State);
mux31 #(1) M2 (1'b1, 1'b1, Buffer[bit_count], State, tx);
mux31 #(1) M3 (1'b0, 1'b1, (bit_count == 4'd9)? 1'b0 : 1'b1, State, tx_busy);
mux31 #(10) M4 (10'd0, {{1'b1},{tx_data},{1'b0}}, 10'd0, State, next_Buffer);
mux31 #(4) M5 (4'd0, 4'd0, ((baud_tick == 1'b1) && (bit_count < 4'd9))? bit_count + 4'd1 : bit_count, State, next_bit_count);
endmodule

//
// reconstructs tx_data with the input received from rx
//
module UART_rx (input clk, reset, rx, baud_tick, output logic [7:0] rx_data, output logic rx_ready);
logic [1:0] State, next_State;
logic [9:0] Buffer, next_Buffer;
logic [3:0] bit_count, next_bit_count;
logic receiving;
localparam RST = 2'b00, DET = 2'b01, REC = 2'b10;
Dreg #(2) D5 (next_State, reset, clk, State);
Dreg #(10) D6 (next_Buffer, reset, clk, Buffer);
Dreg #(4) D7 (next_bit_count, reset, clk, bit_count);
mux31 #(2) M6 (((rx == 1'b0) && (receiving == 1'b0))? DET : RST,(rx == 1'b0)? REC : DET, ((receiving == 1'b0) && (baud_tick == 1'b1))? DET : REC, State, next_State);
mux31 #(1) M7 (1'b0, 1'b1, (bit_count == 4'd9)? 1'b0 : 1'b1, State, receiving);
mux31 #(1) M8 (1'b0, 1'b0, (bit_count == 4'd9)? 1'b1 : 1'b0, State, rx_ready);
mux31 #(8) M9 (8'd0, 8'd0, (bit_count == 4'd9)? Buffer[8:1] : 8'd0, State, rx_data);
mux31 #(10) M10 (10'd0, 10'd0, Buffer | (rx << bit_count), State, next_Buffer);
mux31 #(4) M11 (4'd0, 4'd0, ((baud_tick == 1'b1) && (bit_count < 4'd9))? bit_count + 4'd1 : bit_count, State, next_bit_count);
endmodule

//
// 3:1 mux
//
module mux31 #(parameter N=2) (input [N-1:0] A, B, C, input [1:0] select, output logic [N-1:0] Y);
always_comb begin
	Y = {N{1'b0}};
	case (select)
		2'b00 : Y = A;
		2'b01 : Y = B;
		2'b10 : Y = C;
		default : Y = {N{1'b0}};
	endcase
	end
endmodule

//
// D register
//
module Dreg #(parameter N=2) (input [N-1:0] D, input reset, clk, output logic [N-1:0] Q);
always_ff @ (posedge clk or posedge reset)
	if (reset == 1'b1)
		Q <= {N{1'b0}};
	else
		Q <= D;
endmodule
