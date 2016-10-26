// Alex Dunker
// adunker@purdue.edu

// icache

`include "datapath_cache_if.vh"
`include "cache_control_if.vh"

`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module icache (input logic CLK, nRST, datapath_cache_if dcif, caches_if cif);

	//59 bits wide per row, 16 rows

	logic [31:0] instruction;
	logic [31:0] n_instruction;
	logic [15:0][58:0] cacheValues, n_cacheValues;
	logic [ITAG_W-1:0] tag;
	logic [IIDX_W-1:0] index;
	logic [ITAG_W-1:0] tagToCheck;
	logic valid_chk;
	logic same_tag;
	word_t data_stored;

	assign tag = dcif.imemaddr[31:6];
	assign index = dcif.imemaddr[5:2];
	assign tagToCheck = cacheValues[index][57:32];
	assign valid_chk = cacheValues[index][58];
	assign data_stored = cacheValues[index][31:0];
	assign same_tag = (tagToCheck == tag);

   	integer i;
   	always_ff @(posedge CLK, negedge nRST) begin
      	if (!nRST) begin
        	instruction <= '0; 
         	for (i=0;i<16;i++) begin
            		cacheValues[i][58] <= 0;
         	end
      	end else begin
         	instruction <= n_instruction;
         	cacheValues <= n_cacheValues;
      	end
		end

   	always_comb begin
      		cif.iaddr = 0;
      		dcif.imemload = 0;
		cif.iREN = 0;
		dcif.ihit = 0;
      		n_instruction = instruction;
      		n_cacheValues = cacheValues;

      		if ((dcif.dmemREN == 0) && (dcif.dmemWEN == 0) && (dcif.halt == 0)) begin
         		if(valid_chk && same_tag) begin 
            			dcif.imemload = data_stored;
            			dcif.ihit = 1;
            			n_instruction = data_stored;
			end else begin 
            			cif.iREN = dcif.imemREN;
            			cif.iaddr = dcif.imemaddr;
            			if(cif.iwait == 0) begin
					dcif.ihit = 1;
               				n_cacheValues[index][58] = 1;
               				n_cacheValues[index][57:32] = tag;
               				n_cacheValues[index][31:0] = cif.iload;
               				dcif.imemload = cif.iload;
               				n_instruction = cif.iload;
            			end else begin
               				dcif.imemload = instruction;
            			end
         		end
      		end
  	end

endmodule



