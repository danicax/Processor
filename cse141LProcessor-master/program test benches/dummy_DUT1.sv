/*module dat_mem(input clk);

  logic[7:0] core[256];
  initial
    for(int i=0; i<256; i++)
	  core[i] = '0;
					 
endmodule */

module top_level(
  input clk, init, req,
  output logic ack);

  logic[7:0] addr;
  logic[7:0] datIn, datOut;
  logic[7:0] spaces;
  logic      req_q;

DataMem DM(.Clk(clk), .Reset(init), .WriteEn(1'b0), 
  .DataAddress(addr), .DataIn(datIn), .DataOut(datOut));

logic[7:0] LFSR_state[64], LFSR_taps, LFSR_index;
int ctr;

always @(posedge clk) begin
  req_q <= req;
  if(init || req) begin
    ctr <= 0;
	ack <= 0;
  end														 
  else begin 
	ctr <= ctr+1;
//	case(ctr)
//    endcase
    if(ctr>32) ack <= 1;
  end
end

always @(negedge req) begin
  #30ns;
  LFSR_state[0] = DM.Core[63];
  LFSR_index    = DM.Core[62];
  spaces        = DM.Core[61];
  case(LFSR_index)
    0: LFSR_taps = 7'h60;	
    1: LFSR_taps = 7'h48;
    2: LFSR_taps = 7'h78;
    3: LFSR_taps = 7'h72;
    4: LFSR_taps = 7'h6A;
    5: LFSR_taps = 7'h69;
    6: LFSR_taps = 7'h5C;
    7: LFSR_taps = 7'h7E;
    8: LFSR_taps = 7'h7B;
  endcase
  $displayb(LFSR_state[0],,,,LFSR_taps);
   $display(spaces);
   $display;
  for(int i=0; i<63; i++) begin
    LFSR_state[i+1][6:0] = (LFSR_state[i]<<1)|(^(LFSR_state[i]&LFSR_taps)); 
    LFSR_state[i+1][7] = 1'b0;
    $displayb(LFSR_state[i+1]);
  end
//  $stop;
  for(int i=0; i<spaces; i++) begin
    DM.Core[64+i][6:0] = LFSR_state[i] ^ 8'h20;
	DM.Core[64+i][7] = ^DM.Core[64+i][6:0];
	$displayb(DM.Core[64+i]);
  end
  for(int i=spaces; i<64; i++) begin
    DM.Core[64+i][6:0] = LFSR_state[i] ^ DM.Core[i-spaces];       
    DM.Core[64+i][7] = ^DM.Core[64+i][6:0];
	$displayb(DM.Core[64+i]);
  end
end

endmodule

