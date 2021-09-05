// Create Date:    2018.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2021.07.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			          // includes package "definitions"
module ALU #(parameter W=8, Ops=4)(
	input[W-1:0]	InputA,          // data inputs
					InputB,
	input[Ops-1:0] 	OP,		      // ALU opcode, part of microcode
	output logic [W-1:0] Out,		      // data output 
	output logic BranchFlag      // output = Zero | Positive | Negative
	// you may provide additional status flags, if desired
);	
	logic [10:0] DM64;
	logic [6:0] DM73;
	logic 	Zero,		// zero flag
			Positive;	// positive flag	
				    
		
	op_mne op_mnemonic;			          // type enum: used for convenient waveform viewing

	LFSR_prog2_LUT TapGet(.DM64, .DM73);

	always_comb begin
		Out = 0;                             // No Op = default
		DM64 = 0;
		case(OP)							  
			ADD : Out = InputA + InputB;        // add 
			SUB : Out = InputA + (~InputB) + 1;
			LSH : Out = InputA << InputB;    // shift left, fill in with SC_in 
			RSH : Out = InputA >> InputB;    // shift right
			MOV : Out = InputB;
			XOR : Out = InputA ^ InputB;        // bitwise exclusive OR
			AND : Out = InputA & InputB;        // bitwise AND
			OR 	: Out = InputA | InputB;
			BGE : Out = InputA + (~InputB) + 1;
			BNE : Out = InputA + (~InputB) + 1;
			RXOR: Out = ^InputA[6:0];
			BEQ : Out = InputA + (~InputB) + 1;
			TAPGET : begin 
				DM64 = InputB[6:0] * 9;
				DM64 = DM64 + InputA;
				Out = {!(^DM73), DM73[6:0]};
			end
		endcase
	end

	always_comb begin
		Zero = 0;
		Positive = 0;
		BranchFlag = 0;
		if (OP == BGE || OP == BNE || OP == BEQ) begin
			Zero = !Out;
			Positive = !Out[7];
			if (OP == BGE) begin
				BranchFlag = Zero || Positive;
			end
			if (OP == BEQ) begin
				BranchFlag = Zero;
			end
			if (OP == BNE) begin
				BranchFlag = !Zero;
			end
		end
	end

	always_comb
		op_mnemonic = op_mne'(OP);			  // displays operation name in waveform viewer

endmodule