/*

	Alex Dunker
	adunker@purdue.edu

	Mitch Bouma
	mbouma@purdue.edu

	Forwarding Unit Interface

*/

`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
	// import types
	import cpu_types_pkg::*;

	// output
	logic [1:0] ForwardA, ForwardB;

endinterface // FORWARDING_UNIT_IF_VH

`endif