/*
 Alex Dunker
 adunker@purdue.edu
 
 ALU  Interface
 */

`ifndef ALU_IF_VH
`define ALU_IF_VH

`include "cpu_types_pkg.vh"

//import package types
import cpu_types_pkg::*;

interface alu_if;

   //alu op type
   aluop_t alu_op;
   //32 bit port a, port b, and output
   word_t port_a, port_b, port_o;
   //negative, zero, and overflow
   logic n_fl, z_fl, v_fl;

   //alu file ports
   modport af 
     (
      input port_a, port_b, alu_op,
      output port_o, n_fl, z_fl, v_fl
      );
   //test bench ports
   modport tb
     (
      input port_o, n_fl, z_fl, v_fl,
      output port_a, port_b, alu_op
      );
endinterface // alu_if

`endif