/*

	Alex Dunker
	adunker@purdue.edu

	Decode Pipeline Interface

*/

`ifndef PIPELINE_DECODE_IF_VH
`define PIPELINE_DECODE_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_decode_if;
	// import types
	import cpu_types_pkg::*;

	//decode inputs
	logic [31:0] ID_jump_IN;
	logic [31:0] ID_RegDest_IN;
	logic ID_RegWen_IN;
	logic [31:0] ID_ALUSrc1_IN;
	logic [31:0] ID_ALUSrc2_IN;
	logic [31:0] ID_rdat2_IN;
	aluop_t ID_alu_op_IN;
	logic ID_mem2reg_IN;
	logic ID_pc2reg_IN;
	logic ID_MemWrite_IN;
	logic ID_careOF_IN;
	logic ID_halt_IN;

	//decode outputs
	logic [31:0] ID_Instr_OUT;
	logic [31:0] ID_npc_OUT;

	logic [31:0] ID_jump_OUT;
	logic [31:0] ID_RegDest_OUT;
	logic ID_RegWen_OUT;
	logic [31:0] ID_ALUSrc1_OUT;
	logic [31:0] ID_ALUSrc2_OUT;
	logic [31:0] ID_rdat2_OUT;
	aluop_t ID_alu_op_OUT;
	logic ID_mem2reg_OUT;
	logic ID_pc2reg_OUT;
	logic ID_MemWrite_OUT;
	logic ID_careOF_OUT;
	logic ID_halt_OUT;

endinterface


`endif //PIPELINE_DECODE_IF_VH