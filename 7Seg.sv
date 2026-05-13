//
// decimal to 7-segment display
//
module Dec27Seg (input [7:0] Decimal, output reg [6:0] HexSeg);
	always @ (*) begin
		HexSeg = 7'd0;
		case (Decimal)
//						Numbers
//				0
			8'h0 : HexSeg = 7'b100_0000;
//				1
			8'h1 : HexSeg = 7'b111_1001;
//				2
			8'h2 : HexSeg = 7'b010_0100;
//				3
			8'h3 : HexSeg = 7'b011_0000;
//				4
			8'h4 : HexSeg = 7'b001_1001;
//				5
			8'h5 : HexSeg = 7'b001_0010;
//				6
			8'h6 : HexSeg = 7'b000_0010;
//				7
			8'h7 : HexSeg = 7'b111_1000;
//				8
			8'h8 : HexSeg = 7'b000_0000;
//				9
			8'h9 : HexSeg = 7'b001_0000;
//				turn all the bits off by default
			default : HexSeg = 7'b111_1111;
		endcase
	end
endmodule
