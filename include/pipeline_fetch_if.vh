/*

	Alex Dunker
	adunker@purdue.edu

	Fetch Pipeline Interface

*/

`ifndef PIPELINE_FETCH_IF_VH
`define PIPELINE_FETCH_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_fetch_if;
// import types
import cpu_types_pkg::*;

	//fetch inputs
	logic [31:0] IF_Instr_IN;
	logic [31:0] IF_npc_IN;
	logic flush;

	//fetch outputs
	logic [31:0] IF_Instr_OUT;
	logic [31:0] IF_npc_OUT;


endinterface


`endif //PIPELINE_FETCH_IF_VH