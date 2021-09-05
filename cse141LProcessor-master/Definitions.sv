//This file defines the parameters used in the alu
// CSE141L
//	Rev. 2020.5.27
// import package into each module that needs it
//   packages very useful for declaring global variables
package definitions;
    
// Instruction map
/*  const logic [2:0]ADD  = 3'b000;
    const logic [2:0]LSH  = 3'b001;
    const logic [2:0]RSH  = 3'b010;
    const logic [2:0]XOR  = 3'b011;
    const logic [2:0]AND  = 3'b100;
	const logic [2:0]SUB  = 3'b101;
	const logic [2:0]CLR  = 3'b110;
*/
// enum names will appear in timing diagram
    typedef enum logic[3:0] {
        ADD, SUB, LSH, RSH, MOV, XOR,
        AND, OR, BGE, BNE, RXOR, BEQ, TAPGET } op_mne;
// note: kADD is of type logic[2:0] (3-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
