import definitions::*;
module FetchUnit_tb;
    bit Reset = 'b1,
        Start = 'b1,
        Clk;
    logic [9:0] counter;
    logic [8:0] Instruction;
    logic [1:0] MemToReg, RegDest;
    logic [3:0] ALUOp;
    logic finished = 0, MemWrite, BranchEn, ALUSrc, RegWrite, NextLFSR, RegOut1, RegOut2, Ack;
    op_mne op_mnemonic;	
    InstROM InstructionMemory(.InstAddress(counter), .InstOut(Instruction));
    ProgCtr ProgramCounter(.Reset, .Start, .Clk, .BranchRel(0), .ALUFlag(0), .Target(0), .ProgCtr(counter));
    Ctrl ControlSignals(.Instruction, .MemWrite, .BranchEn, .ALUSrc, .RegWrite, .NextLFSR, .RegOut1, .RegOut2, .Ack, .MemToReg, .RegDest, .ALUOp);
    initial begin
        #10ns Reset = 0;
        #10ns Start = 0;
        for (int i = 0; i < 73; i++) begin
            #10ns $displayb(Instruction);
            $displayb(MemWrite);
            $displayb(BranchEn);
            $displayb(ALUSrc);
            $displayb(RegWrite);
            $displayb(NextLFSR);
            $displayb(RegOut1);
            $displayb(RegOut2);
            $displayb(MemToReg);
            $displayb(RegDest);
            case (ALUOp)
                ADD : $display("ADD");
                SUB : $display("SUB");
                LSH : $display("LSH");
                RSH : $display("RSH");
                MOV : $display("MOV");
                XOR : $display("XOR");
                AND : $display("AND");
                OR 	: $display("OR");
                BGE : $display("BGE");
                BNE : $display("BNE");
                RXOR: $display("RXOR");
                BEQ : $display("BEQ");
                default: $display("NO-ARITHMETIC");
            endcase
            $displayb(Ack);
            if (i == 29) finished = 1;
        end
        wait(finished);
        #10ns $stop;
    end

    always begin   // clock period = 10 Verilog time units
        #5ns  Clk = 'b1;
        #5ns  Clk = 'b0;
    end

    always_comb
		op_mnemonic = op_mne'(ALUOp);
endmodule