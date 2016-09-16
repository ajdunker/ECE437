// Alex Dunker
// adunker@purdue.edu
`ifndef CONTR_UNIT_IF_VH
`define CONTR_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface control_unit_if;
  import cpu_types_pkg::*;

  //input
  logic [31:0] Instr;

  //outputs
  logic [2:0]jump_t;
  logic [1:0] RegDest; //choose dst srouce between Rd and Rt and 31
  logic RegWen; //Enanle when need to write to register
  logic [2:0] ALUsrc; //choose between a register source and an Imediation source and shamt
  aluop_t alu_op;
  logic mem2reg, pc2reg, MemWrite, careOF, halt;

endinterface


`endif