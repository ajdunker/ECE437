/*

	Alex Dunker
	adunker@purdue.edu

	Mitch Bouma
	mbouma@purdue.edu

	Hazard Unit Interface

*/

`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
	// import types
	import cpu_types_pkg::*;

	logic stall;


endinterface

`endif