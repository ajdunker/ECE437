// Alex Dunker
// adunker@purdue.edu

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;
  
  //cache outputs
  assign ccif.iload = (ccif.iREN) ? (ccif.ramload) : '0;
  assign ccif.dload = (ccif.ramload);
  // Wait for access
  assign ccif.iwait = (ccif.ramstate == ACCESS) ? (((ccif.iREN == 1) && (ccif.dWEN != 1) && (ccif.dREN != 1)) ? 0 : 1):1;
  assign ccif.dwait = (ccif.ramstate == ACCESS) ? ((ccif.dREN)? 0 : ((ccif.dWEN) ? 0 : 1)):1;

  //r am outputs
  assign ccif.ramWEN = ccif.dWEN;
  assign ccif.ramREN = (((ccif.dREN == 1) || (ccif.iREN == 1))&&(ccif.dWEN != 1)) ? 1 : 0;
  assign ccif.ramstore = ccif.dstore;
  assign ccif.ramaddr = ((ccif.dREN == 1) || (ccif.dWEN == 1)) ? ccif.daddr : ccif.iaddr;
  
endmodule
