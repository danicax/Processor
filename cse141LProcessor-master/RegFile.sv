// Create Date:    2019.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2

/* parameters are compile time directives 
       this can be an any-width, any-depth reg_file: just override the params!
*/
module RegFile #(parameter W=8, A=3)(		 // W = data path width (leave at 8); A = address pointer width
	input	Clk,
			RegWrite,
			RegOut1,
			RegOut2,
			NextLFSR,
	input [1:0]	RegDest,
	input [A-1:0] 	RaddrA,				 // address pointers
					RaddrB,
					Waddr,
	input [W-1:0]	DataIn,
	output logic [W-1:0] DataOutA,			 // showing two different ways to handle DataOutX, for
	output logic [W-1:0] DataOutB				 //   pedagogic reasons only
);

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [W-1:0] Registers[2**A];	             // or just registers[16] if we know D=4 always
logic [6:0] State;

LFSR LFSR1(.NextLFSR, .RegWrite, .RegDest, .DataIn(DataIn[6:0]),
	.State
);
// combinational reads 
/* can write always_comb in place of assign
    difference: assign is limited to one line of code, so
	always_comb is much more versatile     
*/
always_comb begin
	if (RegOut1) DataOutA = Registers[RaddrB];
	else DataOutA = Registers[RaddrA];
	if(RegOut2) DataOutB = {DataOutA[7], State[6:0]};
	else DataOutB = Registers[RaddrB];
end

// sequential (clocked) writes 
always_ff @ (posedge Clk)
  if (RegWrite && RegDest == 2'b00)	                             // works just like data_memory writes
    Registers[Waddr] <= DataIn;

endmodule
