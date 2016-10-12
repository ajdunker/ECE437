/*

	Alex Dunker
	adunker@purdue.edu

	Decode Pipeline

*/

`include "cpu_types_pkg.vh"
`include "pipeline_fetch_if.vh"
`include "pipeline_decode_if.vh"
`include "hazard_unit_if.vh"

import cpu_types_pkg::*;

module pipeline_decode (
	input logic CLK, nRST,
	pipeline_fetch_if pfif,
	pipeline_decode_if pdif,
	hazard_unit_if huif
);

	logic [31:0] ID_Instr;
	logic [31:0] ID_npc;

	logic [2:0] ID_jump;
	logic [1:0] ID_RegDest;
	logic ID_RegWen;
	logic [2:0] ID_ALUsrc;
	logic [31:0] ID_ALUSrc1;
	logic [31:0] ID_ALUSrc2;
	logic [31:0] ID_rdat2;
	aluop_t ID_alu_op;
	logic ID_mem2reg;
	logic ID_pc2reg;
	logic ID_MemWrite;
	logic ID_careOF;
	logic ID_halt;

	always_ff @(posedge CLK or negedge nRST) begin
		if(nRST == 0) begin
			ID_Instr <= 0;
			ID_npc <= 0;
			ID_jump <= 0;
			ID_RegDest <= 0;
			ID_RegWen <= 0;
			ID_ALUSrc1 <= 0;
			ID_ALUSrc2 <= 0;
			ID_rdat2 <= 0;
			ID_alu_op <= ALU_SLL;
			ID_mem2reg <= 0;
			ID_pc2reg <= 0;
			ID_MemWrite <= 0;
			ID_careOF <= 0;
			ID_halt <= 0;

			ID_ALUsrc <= 0;
		end else begin
			if (huif.hit_check) begin
				if(huif.stall || pfif.flush) begin
					ID_Instr <= 0;
					ID_npc <= 0;
					ID_jump <= 0;
					ID_RegDest <= 0;
					ID_RegWen <= 0;
					ID_ALUSrc1 <= 0;
					ID_ALUSrc2 <= 0;
					ID_rdat2 <= 0;
					ID_alu_op <= ALU_SLL;
					ID_mem2reg <= 0;
					ID_pc2reg <= 0;
					ID_MemWrite <= 0;
					ID_careOF <= 0;
					ID_halt <= 0;
					ID_ALUsrc <= 0;
				end else begin
					ID_Instr <= pfif.IF_Instr_OUT;
					ID_npc <= pfif.IF_npc_OUT;

					ID_jump <= pdif.ID_jump_IN;
					ID_RegDest <= pdif.ID_RegDest_IN;
					ID_RegWen <= pdif.ID_RegWen_IN;
					ID_ALUSrc1 <= pdif.ID_ALUSrc1_IN;
					ID_ALUSrc2 <= pdif.ID_ALUSrc2_IN;
					ID_rdat2 <= pdif.ID_rdat2_IN;
					ID_alu_op <= pdif.ID_alu_op_IN;
					ID_mem2reg <= pdif.ID_mem2reg_IN;
					ID_pc2reg <= pdif.ID_pc2reg_IN;
					ID_MemWrite <= pdif.ID_MemWrite_IN;
					ID_careOF <= pdif.ID_careOF_IN;
					ID_halt <= pdif.ID_halt_IN;

					ID_ALUsrc <= pdif.ID_ALUsrc_IN;
				end
			end
		end
	end

	assign pdif.ID_Instr_OUT = ID_Instr;
	assign pdif.ID_npc_OUT = ID_npc;

	assign pdif.ID_jump_OUT = ID_jump;
	assign pdif.ID_RegDest_OUT = ID_RegDest;
	assign pdif.ID_RegWen_OUT = ID_RegWen;
	assign pdif.ID_ALUSrc1_OUT = ID_ALUSrc1;
	assign pdif.ID_ALUSrc2_OUT = ID_ALUSrc2;
	assign pdif.ID_rdat2_OUT = ID_rdat2;
	assign pdif.ID_alu_op_OUT = ID_alu_op;
	assign pdif.ID_mem2reg_OUT = ID_mem2reg;
	assign pdif.ID_pc2reg_OUT = ID_pc2reg;
	assign pdif.ID_MemWrite_OUT = ID_MemWrite;
	assign pdif.ID_careOF_OUT = ID_careOF;
	assign pdif.ID_halt_OUT = ID_halt;
	assign pdif.ID_ALUsrc_OUT = ID_ALUsrc;

endmodule // pipeline_decode