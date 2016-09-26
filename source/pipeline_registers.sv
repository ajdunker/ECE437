/*

Alex Dunker
adunker@purdue.edu

Mitch Bouma
mbouma@purduedu

Pipeline Registers

*/

// memory types
`include "cpu_types_pkg.vh"
 import cpu_types_pkg::*;

 module pipeline_registers (
 	input logic CLK, nRST,
 	pipeline_registers_if plif

 );


//IF inputs
logic [31:0] IF_Instr_IN;
logic [31:0] IF_NPC_IN;
logic IF_flush;

//ID inputs
logic [2:0] ID_jump_t_IN;
logic [1:0] ID_RegDst_t_IN;
logic ID_RegWen_IN;
logic [31:0] ID_ALUSrc1_IN;
logic [31:0] ID_ALUSrc2_IN;
logic [31:0] ID_RegDat2_IN;
aluop_t ID_ALUOp_IN;
logic ID_MemToReg_IN;
logic ID_PcToReg_IN;
logic ID_MemWrite_IN;
logic ID_careOF_IN;
logic ID_halt_IN;

//EX regs
logic EX_PcToReg;
logic [31:0] EX_NPC;
logic [2:0] EX_jump_t;
logic [31:0] EX_Result;
logic [31:0] EX_Wdata;
logic EX_RegWen;
logic [4:0] EX_RegDst;
logic EX_MemToReg;
logic EX_MemWrite;
logic EX_halt;

//Mem regs
logic MEM_PcToReg;
logic [31:0] MEM_NPC;
logic [31:0] MEM_ReadData;
logic [31:0] MEM_CalcData;
logic [4:0] MEM_RegDst;
logic MEM_RegWen;
logic MEM_MemToReg;
logic MEM_halt;

always_ff @(posedge CLK or negedge nRST) begin
	if(nRST == 0) begin
		//IF regs
  		IF_Instr <= '0;
  		IF_NPC <= '0;

  		//ID regs
  		ID_NPC = '0;
  		ID_Instr <= '0;

  		ID_jump_t <= '0;
  		ID_RegDst_t <= '0;
  		ID_RegWen <= '0;
  		ID_ALUSrc1 <= '0;
  		ID_ALUSrc2 <= '0;
  		ID_RegDat2 <= '0;
  		ID_ALUOp <= ALU_SLL;
  		ID_MemToReg <= '0;
  		ID_PcToReg <= '0;
  		ID_MemWrite <= '0;
  		ID_careOF <= '0;
  		ID_halt <= '0;
  		ID_hazard_care_RT <= 0;

  		//EX regs
  		EX_PcToReg <= '0;
  		EX_NPC <= '0;
  		EX_jump_t <= '0;
  		EX_Result <= '0;
  		EX_Wdata <= '0;
  		EX_RegDst <= '0;
  		EX_RegWen <= '0;
  		EX_MemToReg <= '0;
  		EX_MemWrite <= '0;
  		EX_halt <= 0;

  		//MEM regs
  		MEM_PcToReg <= '0;
  		MEM_NPC <= '0;
  		MEM_ReadData <= '0;
  		MEM_CalcData <= '0;
  		MEM_RegDst <= '0;
  		MEM_MemToReg <= '0;
  		MEM_RegWen <= '0;
  		MEM_halt <= 0;
	end else begin


	end
end

assign plif.IF_Instr_OUT = IF_Instr;

assign plif.ID_NPC_OUT = ID_NPC;
assign plif.ID_Instr_OUT = ID_Instr;
assign plif.ID_ALUSrc1_OUT = ID_ALUSrc1;
assign plif.ID_ALUSrc2_OUT = ID_ALUSrc2;
assign plif.ID_ALUOp_OUT = ID_ALUOp;
assign plif.ID_jump_t_OUT = ID_jump_t;
assign plif.ID_RegDst_t_OUT = ID_RegDst_t;
assign plif.ID_careOF_OUT = ID_careOF;
assign plif.ID_halt_OUT = ID_halt;
assign plif.ID_hazard_care_RT_OUT = ID_hazard_care_RT;
assign plif.ID_RegDat2_OUT = ID_RegDat2;
assign plif.ID_MemToReg_OUT = ID_MemToReg;
assign plif.ID_MemWrite_OUT = ID_MemWrite;

assign plif.EX_Result_OUT = EX_Result;
assign plif.EX_Wdata_OUT =EX_Wdata;
assign plif.EX_RegDst_OUT = EX_RegDst;
assign plif.EX_RegWen_OUT = EX_RegWen;
assign plif.EX_MemToReg_OUT = EX_MemToReg;
assign plif.EX_MemWrite_OUT = EX_MemWrite;

assign plif.MEM_PcToReg_OUT = MEM_PcToReg;
assign plif.MEM_NPC_OUT = MEM_NPC;
assign plif.MEM_MemToReg_OUT = MEM_MemToReg;
assign plif.MEM_RegDst_OUT = MEM_RegDst;
assign plif.MEM_RegWen_OUT = MEM_RegWen;
assign plif.MEM_ReadData_OUT = MEM_ReadData;
assign plif.MEM_CalcData_OUT = MEM_CalcData;
assign plif.MEM_halt_OUT = MEM_halt;


endmodule // pipeline_registers
