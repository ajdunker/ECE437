/*

	Alex Dunker
	adunker@purdue.edu

	Mitch Bouma
	mbouma@purdue.edu

	Forwarding Unit

*/

`include "cpu_types_pkg.vh"
`include "forwarding_unit_if.vh"
`include "pipeline_execute_if.vh"
`include "pipeline_decode_if.vh"
`include "pipeline_memory_if.vh"

import cpu_types_pkg::*;

module forwarding_unit (
	input logic CLK, nRST,
	forwarding_unit_if fuif,
	pipeline_execute_if peif,
	pipeline_decode_if pdif,
	pipeline_memory_if pmif
);
	
	logic [4:0] rt, rs;

	assign rs = pdif.ID_Instr_OUT[25:21];
	assign rt = pdif.ID_Instr_OUT[20:16];

	always_comb begin
		fuif.ForwardA = 0;
		fuif.ForwardB = 0;

		if (pmif.MEM_RegWen_OUT && (pmif.MEM_RegDest_OUT == rs && pmif.MEM_RegDest_OUT != 0) && ((peif.EX_RegDest_OUT != rs) || (peif.EX_RegWen_OUT == 0))) begin
			fuif.ForwardA = 1;
		end else if (peif.EX_RegWen_OUT && (peif.EX_RegDest_OUT == rs && peif.EX_RegDest_OUT != 0)) begin
			fuif.ForwardA = 2;
		end 

		if (pmif.MEM_RegWen_OUT && (pmif.MEM_RegDest_OUT == rt && pmif.MEM_RegDest_OUT != 0) && ((peif.EX_RegDest_OUT != rt) || (peif.EX_RegWen_OUT == 0))) begin
			fuif.ForwardB = 1;
		end else if (peif.EX_RegWen_OUT && (peif.EX_RegDest_OUT == rt && peif.EX_RegDest_OUT != 0) && (rs != rt)) begin
			fuif.ForwardB = 2;
		end

	end

endmodule // hazard_unit