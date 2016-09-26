/*

	Alex Dunker
	adunker@purdue.edu

	Execute Pipeline

*/

`include "cpu_types_pkg.vh"
`include "pipeline_fetch_if.vh"
`include "pipeline_decode_if.vh"
`include "pipeline_execute_if.vh"

import cpu_types_pkg::*;

module pipeline_execute (
	input logic CLK, nRST,
	pipeline_fetch_if pfif,
	pipeline_decode_if pdif,
	pipeline_execute_if peif
);

// execute
logic [31:0] EX_npc;
logic [31:0] EX_result;
logic [31:0] EX_wdat;
logic EX_RegWen;
logic [4:0] EX_RegDest;
logic EX_mem2reg;
logic EX_pc2reg;
logic EX_MemWrite;
logic EX_halt;


	always_ff @(posedge CLK or negedge nRST) begin
		if(nRST == 0) begin
			EX_npc <= 0;
			EX_result <= 0;
			EX_wdat <= 0;
			EX_RegWen <= 0;
			EX_RegDest <= 0;
			EX_mem2reg <= 0;
			EX_pc2reg <= 0;
			EX_MemWrite <= 0;
			EX_halt <= 0;
		end else begin
			EX_npc <= pdif.ID_npc_OUT;
			EX_result <= peif.EX_result_IN;
			EX_wdat <= peif.EX_wdat_IN;
			EX_RegWen <= pdif.ID_RegWen_OUT;
			EX_RegDest <= peif.EX_RegDest_IN;
			EX_mem2reg <= pdif.ID_mem2reg_OUT;
			EX_pc2reg <= pdif.ID_pc2reg_OUT;
			EX_MemWrite <= pdif.ID_MemWrite_OUT;
			EX_halt <= pdif.ID_halt_OUT;
		end
	end

	assign peif.EX_npc_OUT = EX_npc;
	assign peif.EX_result_OUT = EX_result;
	assign peif.EX_wdat_OUT = EX_wdat;
	assign peif.EX_RegWen_OUT = EX_RegWen;
	assign peif.EX_RegDest_OUT = EX_RegDest;
	assign peif.EX_mem2reg_OUT = EX_mem2reg;
	assign peif.EX_pc2reg_OUT = EX_pc2reg;
	assign peif.EX_MemWrite_OUT = EX_MemWrite;
	assign peif.EX_halt_OUT = EX_halt;

endmodule // pipeline_execute