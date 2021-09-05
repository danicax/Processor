// program 2 LFSR tap pattern detective work module
//  lookup table: drive from data_out port[6:0] for data_mem[64] and a 4-bit counter
//  compare output to data_out port[6:0] for data_mem[73]
// incrementing the 4-bit counter from 0 through 8 will step through the 9 possible
//   maximal length LFSR tap patterns
module LFSR_prog2_LUT(
  input logic [10:0] DM64,
  output logic[6:0] DM73);

  logic[6:0] core[2048];

  initial 
    $readmemb("lut9.txt",core);

  always_comb begin
    DM73 = core[DM64];
  end

endmodule