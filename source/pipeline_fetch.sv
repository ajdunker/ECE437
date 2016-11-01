/*

	Alex Dunker
	adunker@purdue.edu

	Fetch Pipeline

*/

`include "cpu_types_pkg.vh"
`include "pipeline_fetch_if.vh"
`include "hazard_unit_if.vh"

import cpu_types_pkg::*;

module pipeline_fetch (
	input logic CLK, nRST, dhit,
	pipeline_fetch_if pfif,
	hazard_unit_if huif
);

	//IF inputs
	logic [31:0] IF_Instr;
	logic [31:0] IF_npc;

	always_ff @(posedge CLK or negedge nRST) begin 
		if(nRST == 0) begin
			IF_Instr <= '0;
	  		IF_npc <= '0;
		end else begin
			if (huif.hit_check && !huif.hit_check2) begin
				if(~huif.stall && ~pfif.flush) begin
					IF_Instr <= pfif.IF_Instr_IN;
					IF_npc <= pfif.IF_npc_IN;
				end else if (pfif.flush) begin
					IF_Instr <= '0;
					IF_npc <= '0;
				end
			end
		end
	end

	assign pfif.IF_Instr_OUT = IF_Instr;
	assign pfif.IF_npc_OUT = IF_npc;

endmodule 