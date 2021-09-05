/* CSE141L
   possible lookup table for PC target
   leverage a few-bit pointer to a wider number
   Lookup table acts like a function: here Target = f(Addr);
 in general, Output = f(Input); lots of potential applications 
*/
module LUT(
  input       [ 3:0] TapIndex,
  output logic[ 6:0] Tap
  );

always_comb begin
  case(TapIndex)		   
	4'b0000:		Tap = 7'h60;   // -16, i.e., move back 16 lines of machine code
	4'b0001:		Tap = 7'h48;
	4'b0010:		Tap = 7'h78;
	4'b0011:		Tap = 7'h72;
	4'b0100:		Tap = 7'h6A;
	4'b0101:		Tap = 7'h69;
	4'b0110:		Tap = 7'h5C;
	4'b0111:		Tap = 7'h7E;
	default:	Tap = 7'h7B;
  endcase
end

endmodule