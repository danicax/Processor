// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
	input[ 8:0] Instruction,	   // machine code
	output logic	MemWrite,
					BranchEn,
					RegWrite,
					NextLFSR,
					RegOut1,
					RegOut2,
					Ack,      // "done w/ program"
	output logic[1:0] 	MemToReg,
  						RegDest,
						ALUSrc,
	output logic [3:0] ALUOp
  );

logic [1:0] S;

always_latch begin
	MemWrite = 0;
	BranchEn = 0;
	ALUSrc = 2'b00;
	RegWrite = 0;
	NextLFSR = 0;
	RegOut1 = 0;
	RegOut2 = 0;
	MemToReg = 2'b00;
	RegDest = 2'b00;
	ALUOp = 4'b0000;
	if (Instruction[8:6] == 3'b110) begin //set
		S = Instruction[1:0];
	end
	else begin
		if (Instruction[8:6] == 3'b000 && S == 2'b00) begin // Load
			MemToReg = 2'b01;
		end

		if (Instruction[8:6] == 3'b001 && S == 2'b11) begin // setLFSR
			MemToReg = 2'b11;
			RegDest = 2'b01;
		end

		if (Instruction[8:6] == 3'b011 && S == 2'b01) begin // setTap
			MemToReg = 2'b11;
			RegDest = 2'b10;
			RegOut1 = 1;
		end

		if (Instruction[8:6] == 3'b000 && S == 2'b01) begin // Store
			MemWrite = 1;
		end

		if ((Instruction[8:6] == 3'b011 && (S == 2'b10 || S == 2'b11)) || (Instruction[8:6] == 3'b100 && S == 2'b01)) begin //Branch BGE, BNE, BEQ
			BranchEn = 1;
		end

		if ((Instruction[8:6] == 3'b000 && (S == 2'b00 || S == 2'b01)) || Instruction[8:6] == 3'b001) begin // Load/Store, left shift, right shift, mov immediate, set lfsr
			ALUSrc = 2'b01;
		end

		if ((S != 2'b01 && (Instruction[8:6] == 3'b000 || Instruction[8:6] == 3'b010)) || Instruction[8:6] == 3'b001 || (Instruction[8:6] == 3'b011 && (S == 2'b00 || S == 2'b01)) || (Instruction[8:6] == 3'b100 && S != 2'b01)) begin
			RegWrite = 1; // Load, Add, Sub, Left, Right, Mov immediate, setLFSR, OR, setTap, reduction XOR, XOR, XOR, AND, getTap
		end

		if (Instruction[8:6] == 3'b010 && S == 2'b01) begin // Next
			NextLFSR = 1;
		end

		if ((Instruction[8:6] == 3'b010 && S == 2'b00) || (Instruction[8:6] == 3'b100 && S != 2'b01)) begin // XOR, reduction XOR, getTap
			RegOut1 = 1;
			RegOut2 = 1;
		end
		if (Instruction[8:6] == 3'b100 && S == 2'b10) begin // getTap
			ALUSrc = 2'b10;
		end
		
		case (Instruction[8:6])
			3'b000: begin
				if (S == 2'b11) ALUOp = 4'b0001; // Sub register
			end
			3'b001: begin
				if (S == 2'b00) ALUOp = 4'b0010; // Left shift
				else if (S == 2'b01) ALUOp = 4'b0011; //Right shift
				else ALUOp = 4'b0100; // Mov immediate, setLFSR
			end
			3'b010: begin
				if (S == 2'b11) ALUOp = 4'b0110; //AND
				else ALUOp = 4'b0101; // XOR, Next, XOR
			end
			3'b011: begin
				if (S == 2'b10) ALUOp = 4'b1000; // Branch BGE
				else if (S == 2'b11) ALUOp = 4'b1001; // Branch BNE
				else ALUOp = 4'b0111; // OR, setTap
			end
			3'b100: begin
				if (S == 2'b00) ALUOp = 4'b1010; // Reduction XOR
				else if (S == 2'b10) ALUOp = 4'b1100; // getTap
				else ALUOp = 4'b1011; //Branch BEQ
			end 
		endcase

	end
end

assign Ack = (Instruction[8:6] == 3'b111) ? 1 : 0;

endmodule

