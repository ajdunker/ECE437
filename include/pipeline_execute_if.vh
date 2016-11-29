/*

	Alex Dunker
	adunker@purdue.edu

	Execute Intereface

*/

`ifndef PIPELINE_EXECUTE_IF_VH
`define PIPELINE_EXECUTE_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_execute_if;
	// import types
	import cpu_types_pkg::*;
	
	// in
	logic [31:0] EX_npc_IN;
	logic [31:0] EX_result_IN;
	logic [31:0] EX_wdat_IN;
	logic EX_RegWen_IN;
	logic [4:0] EX_RegDest_IN;
	logic EX_mem2reg_IN;
	logic EX_pc2reg_IN;
	logic EX_MemWrite_IN;
	logic EX_halt_IN;
	logic EX_atomic_IN;
	
	// out
	logic [31:0] EX_npc_OUT;
	logic [31:0] EX_result_OUT;
	logic [31:0] EX_wdat_OUT;
	logic EX_RegWen_OUT;
	logic [4:0] EX_RegDest_OUT;
	logic EX_mem2reg_OUT;
	logic EX_pc2reg_OUT;
	logic EX_MemWrite_OUT;
	logic EX_halt_OUT;
	logic EX_atomic_OUT;

endinterface


`endif //PIPELINE_EXECUTE_IF_VH