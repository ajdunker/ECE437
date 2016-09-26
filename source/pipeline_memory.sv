/*

	Alex Dunker
	adunker@purdue.edu

	Memory Pipeline

*/

`include "cpu_types_pkg.vh"
`include "pipeline_fetch_if.vh"
`include "pipeline_decode_if.vh"
`include "pipeline_execute_if.vh"
`include "pipeline_memory_if.vh"

import cpu_types_pkg::*;

module pipeline_memory (
	input logic CLK, nRST,
	pipeline_fetch_if pfif,
	pipeline_decode_if pdif,
	pipeline_execute_if peif,
	pipeline_memory_if pmif
);

	logic [31:0] MEM_npc;
	logic [31:0] MEM_rdat;
	logic [31:0] MEM_result;
	logic [4:0] MEM_RegDest;
	logic MEM_RegWen;
	logic MEM_pc2reg;
	logic MEM_mem2reg;
	logic MEM_halt;

	always_ff @(posedge CLK or negedge nRST) begin
		if(nRST == 0) begin
			MEM_npc <= 0;
			MEM_rdat <= 0;
			MEM_result <= 0;
			MEM_RegDest <= 0;
			MEM_RegWen <= 0;
			MEM_pc2reg <= 0;
			MEM_mem2reg <= 0;
			MEM_halt <= 0;
		end else begin
			MEM_npc <= peif.EX_npc_OUT;
			MEM_rdat <= pmif.MEM_rdat_IN;
			MEM_result <= peif.EX_result_OUT;
			MEM_RegDest <= peif.EX_RegDest_OUT;
			MEM_RegWen <= peif.EX_RegWen_OUT;
			MEM_mem2reg <= peif.EX_mem2reg_OUT;
			MEM_pc2reg <= peif.EX_pc2reg_OUT;
			MEM_halt <= peif.EX_halt_OUT;
		end
	end

	assign pmif.MEM_npc_OUT = MEM_npc;
	assign pmif.MEM_rdat_OUT = MEM_rdat;
	assign pmif.MEM_result_OUT = MEM_result;
	assign pmif.MEM_RegDest_OUT = MEM_RegDest;
	assign pmif.MEM_RegWen_OUT = MEM_RegWen;
	assign pmif.MEM_pc2reg_OUT = MEM_pc2reg;
	assign pmif.MEM_mem2reg_OUT = MEM_mem2reg;
	assign pmif.MEM_halt_OUT = MEM_halt;

endmodule // pipeline_memory