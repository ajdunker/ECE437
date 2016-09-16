// Alex Dunker
// adunker@purdue.edu

`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface request_unit_if;
  import cpu_types_pkg::*;

  //input
  logic mem2reg;
  logic MemWrite;
  logic dhit;
  logic ihit;

  //outputs
  logic dmemREN;
  logic dmemWEN;

endinterface


`endif