import definitions::*;
module ALU_tb;
    logic [7:0] InputA, InputB, Output;
    logic [3:0] OP;
    logic BranchFlag;
    op_mne op_mnemonic;	
    ALU TestingALU(.InputA, .InputB, .OP, .Out(Output), .BranchFlag);
    initial begin
        #10ns InputA = 8'b00001010;
        #10ns InputB = 8'b00000001;
        #10ns for (logic[3:0] i = 4'b0; i < 12; i++) begin
            OP = i;
            case (OP)
                ADD : #10ns $display("ADD");
                SUB : #10ns $display("SUB");
                LSH : #10ns $display("LSH");
                RSH : #10ns $display("RSH");
                MOV : #10ns $display("MOV");
                XOR : #10ns $display("XOR");
                AND : #10ns $display("AND");
                OR 	: #10ns $display("OR");
                BGE : #10ns $display("BGE");
                BNE : #10ns $display("BNE");
                RXOR: #10ns $display("RXOR");
                BEQ : #10ns $display("BEQ");
            endcase
                
            #10ns $display("Input A: ", InputA);
            #10ns $display("Input B: ", InputB);
            #10ns $display("Output: ", Output);
            #10ns $display("Branch Flag: ", BranchFlag);
            #10ns $display("\n\n");
        end
        #10ns $stop;
    end		
    always_comb
		op_mnemonic = op_mne'(OP);
endmodule