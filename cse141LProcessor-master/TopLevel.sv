// Revision Date:    2020.08.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input        Reset,	   // init/reset, active high
			     Start,    // start next program
	             Clk,	   // clock -- posedge used inside design
    output logic Ack	   // done flag from DUT
    );

logic [ 9:0] PgmCtr, Target;
logic [ 8:0] Instruction;   // our 9-bit opcode
logic [ 7:0] ReadA, ReadB;  // reg_file outputs
logic [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
logic [ 7:0] RegWriteValue, // data in to reg file
	   	    MemReadValue,
			Mem64;  // data out from data_memory
logic       MemWrite,	   // data_memory write enable
			BranchEn,	   // to program counter: branch enable
			RegWrite,	   // reg_file write enable
			NextLFSR,
			RegOut1,
			RegOut2,
			BranchFlag;		   // ALU output = 0 flag
logic [1:0]	MemToReg,
			ALUSrc,
			RegDest;
logic [3:0]	ALUOp;
logic [2:0] RaddrA, RaddrB;
logic[15:0] CycleCt;	   // standalone; NOT PC!

// Fetch stage = Program Counter + Instruction ROM
  ProgCtr PC1 (		             // this is the program counter module
	.Reset        (Reset),   // reset to 0
	.Start        (Start),   // SystemVerilog shorthand for .grape(grape) is just .grape 
	.Clk          (Clk),   //    here, (Clk) is required in Verilog, optional in SystemVerilog
	.BranchRel    (BranchEn),  // branch enable
	.ALUFlag	  (BranchFlag),
    .Target,   // "where to?" or "how far?" during a jump or branch
	.ProgCtr      (PgmCtr)	 // program count = index to instruction memory
	);					  

// instruction memory -- holds the machine code pointed to by program counter
  InstROM #(.W(9)) IR1(
	.InstAddress  (PgmCtr), 
	.InstOut      (Instruction)
	);

// Decode stage = Control Decoder + Reg_file
// Control decoder
  Ctrl Ctrl1 (
	.Instruction  	(Instruction) ,  // from instr_ROM
	.MemWrite		(MemWrite),
	.BranchEn    	(BranchEn),  // to PC
	.ALUSrc			(ALUSrc),
	.RegWrite      	(RegWrite),  // register file write enable
	.NextLFSR		(NextLFSR),
	.RegOut1		(RegOut1),
	.RegOut2		(RegOut2),
	.MemToReg		(MemToReg),
	.RegDest		(RegDest),
	.ALUOp			(ALUOp),
    .Ack          	(Ack)	   // "done" flag
  );

// reg file
	RegFile #(.W(8),.A(3)) RF1 (			  // D(3) makes this 8 elements deep
 	  .Clk,
	  .RegWrite  (RegWrite), 
	  .RegOut1	 (RegOut1),
	  .RegOut2	 (RegOut2),
	  .NextLFSR	 (NextLFSR),
	  .RegDest	 (RegDest),
	  .RaddrA,        //concatenate with 0 to give us 4 bits
	  .RaddrB, 
	  .Waddr     (Instruction[5:3]), 	      // mux above
	  .DataIn    (RegWriteValue), 
	  .DataOutA  (ReadA), 
	  .DataOutB  (ReadB)
	);
/* one pointer, two adjacent read accesses: 
  (sample optional approach)
	.raddrA ({Instruction[5:3],1'b0});
	.raddrB ({Instruction[5:3],1'b1});
*/
	always_comb begin
		InA = ReadA;
		RaddrB = Instruction[2:0];
		RaddrA = Instruction[5:3];
		if (Instruction[8:6] == 3'b000 && (MemWrite || MemToReg == 2'b01)) begin
			RaddrB = 3'b000;
			InA = ReadB;
		end
		else if (BranchEn) begin
			RaddrA = 3'b011;
			RaddrB = 3'b100;
		end
		if (ALUSrc == 2'b01) begin
			InB = {5'b00000, Instruction[2:0]};
		end
		else if (ALUSrc == 2'b00) begin
			InB = ReadB;
		end
		else begin
			InB = Mem64 ^ 8'b00100000;
			InB = InB - 1;
		end
		if (MemToReg == 2'b00) begin
			RegWriteValue = ALU_out;
		end
		else if (MemToReg == 2'b01) begin
			RegWriteValue = MemReadValue;
		end
		else if (MemToReg == 2'b10) begin
			RegWriteValue = {5'b00000, Instruction[2:0]};
		end
		else begin
			RegWriteValue = ReadB;
		end
		if (Instruction[5] == 0) begin
			Target = {4'b0000, Instruction[5:0]};
		end
		else begin
			Target = {4'b1111, Instruction[5:0]};
		end
	end
    ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB), 
	  .OP      (ALUOp),
	  .Out     (ALU_out),                    //regWriteValue),
	  .BranchFlag (BranchFlag)                       // status flag; may have others, if desired
	  );
  
	DataMem DM1(
		.DataAddress  (ALU_out), 
		.MemWrite     (MemWrite), 
		.DataIn       (ReadA), 
		.DataOut      (MemReadValue) ,
		.Mem64,
		.Clk,
		.Reset		  (Reset)
	);
	
/* count number of instructions executed
      not part of main design, potentially useful
      This one halts when Ack is high  
*/
always_ff @(posedge Clk)
  if (Reset)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule