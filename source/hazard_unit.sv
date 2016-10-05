/*

	Alex Dunker
	adunker@purdue.edu

	Mitch Bouma
	mbouma@purdue.edu

	Hazard Unit

*/

`include "cpu_types_pkg.vh"
`include "hazard_unit_if.vh"

`include "pipeline_fetch_if.vh"
`include "pipeline_decode_if.vh"
`include "datapath_cache_if.vh"



import cpu_types_pkg::*;

module hazard_unit (
	input logic CLK, nRST,
	hazard_unit_if huif,
	pipeline_fetch_if pfif,
	pipeline_decode_if pdif,
	datapath_cache_if.dp dpif
);

	logic [4:0] id_rt, if_rs, if_rt;

	assign id_rt = pdif.ID_Instr_OUT[20:16];	

	assign if_rs = pfif.IF_Instr_OUT[25:21];
	assign if_rt = pfif.IF_Instr_OUT[20:16];

	assign huif.hit_check = dpif.ihit | dpif.dhit;

	always_comb begin
		if (pdif.ID_mem2reg_OUT && ((id_rt == if_rs) || (id_rt == if_rt))) begin
			huif.stall = 1;
		end else begin
			huif.stall = 0;
		end
	end


endmodule // hazard_unit