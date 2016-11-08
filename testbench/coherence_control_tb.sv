// Alex Dunker
// adunker@purdue.edu
// Mitch Bouma
// mbouma@purdue.edu

// Coherence Controller TB

`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module coherence_control_tb;

  parameter PERIOD = 10;
  parameter WAIT = 1;

  logic CLK = 0, nRST;

  always #(PERIOD/2) CLK++;

  cache_control_if ccif();

  // test program
  test PROG (CLK, nRST, ccif);
 
  // DUT
  coherency_control DUT(CLK, nRST, ccif);

endmodule

program test(
	input logic CLK, nRST,
	cache_control_if ccif
);
  
  parameter PERIOD = 10;

	initial begin
    #4;
    nRST = 0;
    #(PERIOD)
    nRST = 1;
    #(PERIOD)
    ccif.daddr[0] = 32'hdeadbeef;
    ccif.daddr[1] = 32'hgocubsgo;

    ccif.cctrans[0] = 1;
    ccif.cctrans[1] = 0;
    ccif.ccwrite[0] = 0;
    ccif.ccwrite[1] = 0;
    ccif.dwait[0] = 1;
    ccif.dwait[1] = 1;

    #(PERIOD)


	end
	

endprogram