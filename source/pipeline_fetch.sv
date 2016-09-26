/*

	Alex Dunker
	adunker@purdue.edu

	Fetch Pipeline

*/

`include "cpu_types_pkg.vh"
`include "pipeline_fetch_if.vh"

import cpu_types_pkg::*;

module pipeline_fetch (
	input logic CLK, nRST,
	pipeline_fetch_if pfif
);

	//IF inputs
	logic [31:0] IF_Instr;
	logic [31:0] IF_npc;

	always_ff @(posedge CLK or negedge nRST) begin
		if(nRST == 0) begin
			IF_Instr <= '0;
	  		IF_npc <= '0;
		end else begin
			IF_Instr <= pfif.IF_Instr_IN;
			IF_npc <= pfif.IF_npc_IN;
		end
	end

	assign pfif.IF_Instr_OUT = IF_Instr;
	assign pfif.IF_npc_OUT = IF_npc;

endmodule // pipeline_registers