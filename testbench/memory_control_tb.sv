/*

  Alex Dunker
  Mitch Bouma

  adunker@purdue.edu
  mbouma@purdue.edu

  memory control test bench
*/

// mapped needs this
`include "cpu_types_pkg.vh"
`include "cache_control_if.vh"
`include "caches_if.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if c_if1();
  caches_if c_if2();	
  cache_control_if ccif(c_if1, c_if2); 

  // test program
  test PROG (CLK, nRST, ccif);

  // DUT
  memory_control DUT(CLK, nRST, ccif);



endmodule


program test(input logic CLK, output logic nRST, cache_control_if ccif);

  parameter PERIOD = 10;

  initial begin
    // Test Code
    @(posedge CLK);

    nRST = 1'b0;

    @(posedge CLK);

    nRST = 1'b1;
    
    //reset values
    c_if1.iREN = '0;
    c_if1.dREN = '0;
    c_if1.dWEN = '0;
    c_if1.cctrans = '0;
    c_if1.ccwrite = '0;

    //go from IDLE to FETCH back to IDLE
    //in IDLE
    c_if1.iREN = 1;
    @(posedge CLK);
    //in FETCH
    ccif.ramstate = ACCESS;
    @(posedge CLK);
    //in IDLE

    //reset values
    c_if1.iREN = 0;
    c_if2.iREN = 0;
    c_if1.dREN = '0;
    c_if1.dWEN = '0;
    c_if1.cctrans = '0;
    c_if1.ccwrite = '0;

    //go from IDLE to SNOOP to LOAD1 to LOAD2 back to IDLE
    //in IDLE
    c_if1.dREN = 1;
    c_if1.cctrans = 1;
    c_if1.ccwrite = 0;
    @(posedge CLK);
    //in SNOOP
    c_if2.cctrans = 0;
    @(posedge CLK);
    //in LOAD1
    c_if1.ccwrite = 1;
    @(posedge CLK);
    //in LOAD2
    ccif.ramstate = ACCESS;
    @(posedge CLK);
    //in IDLE

    //reset values
    c_if1.iREN = '0;
    c_if1.dREN = '0;
    c_if1.dWEN = '0;
    c_if1.cctrans = '0;
    c_if1.ccwrite = '0;

    //go from IDLE to SNOOP to PUSH1 to PUSH2 back to IDLE
    //in IDLE
    c_if1.dREN = 1;
    c_if1.cctrans = 1;
    c_if1.ccwrite = 0;
    @(posedge CLK);
    //in SNOOP
    c_if2.cctrans = 1;
    @(posedge CLK);
    //in PUSH1
    c_if1.ccwrite = 1;
    @(posedge CLK);
    //in PUSH2
    ccif.ramstate = ACCESS;
    @(posedge CLK);
    //in IDLE

    //reset values
    c_if1.iREN = '0;
    c_if1.dREN = '0;
    c_if1.dWEN = '0;
    c_if1.cctrans = '0;
    c_if1.ccwrite = '0;

    //go from IDLE to WRITEBACKK1 to WRITEBACK2 back to IDLE
    //in IDLE
    c_if1.dWEN = 1;
    c_if1.cctrans = 1;
    c_if1.ccwrite = 0;
    @(posedge CLK);
    //in WRITEBACK1
    @(posedge CLK);
    //in WRITEBACK2
    @(posedge CLK);
    //in IDLE

    @(posedge CLK);

  end


endprogram


