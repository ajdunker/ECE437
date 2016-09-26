/*

	Alex Dunker
	adunker@purdue.edu

	Memory Pipeline Interface

*/

`ifndef PIPELINE_MEMORY_IF_VH
`define PIPELINE_MEMORY_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_memory_if;
// import types
import cpu_types_pkg::*;

	//fetch inputs
	logic [31:0] MEM_npc_IN;
	logic [31:0] MEM_rdat_IN;
	logic [31:0] MEM_result_IN;
	logic [4:0] MEM_RegDest_IN;
	logic MEM_RegWen_IN;
	logic MEM_pc2reg_IN;
	logic MEM_mem2reg_IN;
	logic MEM_halt_IN;

	//fetch outputs
	logic [31:0] MEM_npc_OUT;
	logic [31:0] MEM_rdat_OUT;
	logic [31:0] MEM_result_OUT;
	logic [4:0] MEM_RegDest_OUT;
	logic MEM_RegWen_OUT;
	logic MEM_pc2reg_OUT;
	logic MEM_mem2reg_OUT;
	logic MEM_halt_OUT;

endinterface


`endif //PIPELINE_MEMORY_IF_VH