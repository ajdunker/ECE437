// Alex Dunker
// adunker@purdue.edu

// icache

`include "datapath_cache_if.vh"
`include "cache_control_if.vh"

`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module icache (
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if cif
);

   logic [31:0] instr;
   logic [31:0] n_instr;

   /***** I_Cache *****/
   //16 slots, 512 bits
   //tag[57:32], data[31:0], valid[58]
   logic [15:0][58:0] cacheReg, n_cacheReg;

   //values for checking icache
   logic [ITAG_W-1:0] tag;
   logic [IIDX_W-1:0] index;

   logic [ITAG_W-1:0] tag_chk;
   logic valid_chk;

   logic same_tag;
   word_t data_stored;

   assign tag = dcif.imemaddr[31:6];
   assign index = dcif.imemaddr[5:2];

   assign tag_chk = cacheReg[index][57:32];
   assign valid_chk = cacheReg[index][58];

   assign data_stored = cacheReg[index][31:0];
   assign same_tag = (tag_chk == tag) ? 1 : 0;

   integer i;

   always_ff @(posedge CLK, negedge nRST) begin
      if (!nRST) begin
         instr <= '0; 
         for (i=0;i<16;i++) begin
            cacheReg[i][58] <= 0;
         end
      end else begin
         instr <= n_instr;
         cacheReg <= n_cacheReg;
      end
	end

   // icache comb logic
   always_comb begin
      //default value, prevent latch
      dcif.ihit = 0;
      cif.iREN = 0;
      cif.iaddr = 0;
      dcif.imemload = 0;
      n_instr = instr;
      n_cacheReg = cacheReg;

      if((dcif.dmemREN == 0) && (dcif.dmemWEN == 0) && (dcif.halt == 0)) begin
         if(valid_chk && same_tag) begin //found a match
            dcif.imemload = data_stored;
            dcif.ihit = 1;
            n_instr = data_stored;
         end else begin //match not found, requesting from mem
            cif.iREN = dcif.imemREN;
            cif.iaddr = dcif.imemaddr;
            if(cif.iwait == 0) begin
               n_cacheReg[index][58] = 1; //set valid
               n_cacheReg[index][57:32] = tag; //set tag
               n_cacheReg[index][31:0] = cif.iload; //store data
               dcif.ihit = 1;
               dcif.imemload = cif.iload;
               n_instr = cif.iload;
            end else begin
               dcif.imemload = instr;
            end
         end
      end
  end
endmodule // icache
