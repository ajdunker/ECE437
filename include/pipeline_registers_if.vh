//

`ifndef PIPELINE_REGISTER_IF_VH
`define PIPELINE_REGISTER_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pipeline_registers_if;
// import types
import cpu_types_pkg::*;

//inputs
logic tick;
logic lw_hazard;
logic [1:0]lw_later_hazard;
logic branching;

//IF inputs
logic [31:0] IF_Instr_IN;
logic [31:0] IF_NPC_IN;

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
logic ID_hazard_care_RT_IN;

//EX inputs
//logic [31:0] EX_NPC_IN;
logic [31:0] EX_Wdata_IN;
logic [4:0] EX_RegDst_IN;
logic [31:0] EX_Result_IN;

//MEM inputs
logic [31:0] MEM_ReadData_IN;

//outputs
//IF outputs
logic [31:0] IF_Instr_OUT;

//ID outputs
logic [31:0] ID_NPC_OUT;
logic [31:0] ID_Instr_OUT;
logic [31:0] ID_ALUSrc1_OUT;
logic [31:0] ID_ALUSrc2_OUT;
aluop_t ID_ALUOp_OUT;
logic [2:0] ID_jump_t_OUT;
logic [1:0] ID_RegDst_t_OUT;
logic ID_careOF_OUT;
logic ID_halt_OUT;
logic ID_hazard_care_RT_OUT;
logic [31:0] ID_RegDat2_OUT; 
logic ID_MemToReg_OUT;
logic ID_MemWrite_OUT;

//EX outputs
//logic EX_ALUZero_OUT;
//logic [2:0] EX_jump_t_OUT;
logic [31:0] EX_Result_OUT;
logic [31:0] EX_Wdata_OUT;
logic [4:0]  EX_RegDst_OUT;
logic EX_RegWen_OUT;
logic EX_MemToReg_OUT;
logic EX_MemWrite_OUT;

//MEM outputs
logic MEM_PcToReg_OUT;
logic [31:0] MEM_NPC_OUT;
logic MEM_MemToReg_OUT;
logic [4:0] MEM_RegDst_OUT;
logic MEM_RegWen_OUT;
logic [31:0] MEM_ReadData_OUT;
logic [31:0] MEM_CalcData_OUT;
logic MEM_halt_OUT;

endinterface

`endif //PIPELINE_REGISTER_IF_VH
