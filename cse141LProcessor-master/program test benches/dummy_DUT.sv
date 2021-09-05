/*module dat_mem(input clk);

  logic[7:0] core[256];
  initial
    for(int i=0; i<256; i++)
	  core[i] = '0;
					 
endmodule */

module top_level(
  input clk, init, req,
  output logic ack);

DataMem DM(.Clk(clk), .Reset(init), .WriteEn(0), 
  .DataAddress(), .DataIn(), .DataOut());

logic[7:0] LFSR_state[64];
int ctr;

always @(posedge clk) begin
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

endmodule

