/*

  Alex Dunker
  Mitch Bouma

  adunker@purdue.edu
  mbouma@purdue.edu

  memory control test bench
*/

// mapped needs this
`include "cache_control_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;
  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  cache_control_if ccif(); 

  // test program
  test PROG (CLK, nRST, ccif);
  memory_control MC (CLK, nRST, ccif);

endmodule

program test(
  input logic CLK, 
  output logic nRST,
  cache_control_if ccif,
);

  parameter PERIOD = 10;

  initial begin
    // Test Code
    @(posedge CLK);

    nRST = 1'b0;

    @(posedge CLK);

    nRST = 1'b1;
    
    //reset values
    ccif.iREN = '0;
    ccif.dREN = '0;
    ccif.dWEN = '0;
    ccif.cctrans = '0;
    ccif.ccwrite = '0;

    //go from IDLE to FETCH back to IDLE
    //in IDLE
    assign ccif.iREN[0] = 1;
    @(posedge CLK);
    //in FETCH
    @(posedge CLK);
    //in IDLE

    //reset values
    ccif.iREN = '0;
    ccif.dREN = '0;
    ccif.dWEN = '0;
    ccif.cctrans = '0;
    ccif.ccwrite = '0;

    //go from IDLE to ARBITRATE to SNOOP to LOAD1 to LOAD2 back to IDLE
    //in IDLE
    assign ccif.dREN[0] = 1;
    @(posedge CLK);
    //in ARBITRATE
    ccif.dREN[0] = 1;
    @(posedge CLK);
    //in SNOOP
    assign ccif.cctrans[0] = 1;
    assign ccif.ccwrite[0] = 1;
    @(posedge CLK);
    //in LOAD1
    @(posedge CLK);
    //in LOAD2
    @(posedge CLK);
    //in IDLE

    //reset values
    ccif.iREN = '0;
    ccif.dREN = '0;
    ccif.dWEN = '0;
    ccif.cctrans = '0;
    ccif.ccwrite = '0;

    //go from IDLE to ARBITRATE to SNOOP to PUSH1 to PUSH2 back to IDLE
    //in IDLE
    assign ccif.dREN[0] = 1;
    @(posedge CLK);
    //in ARBITRATE
    ccif.dREN[0] = 1;
    @(posedge CLK);
    //in SNOOP
    assign ccif.cctrans[0] = 0;
    assign ccif.cctrans[1] = 0;
    assign ccif.ccwrite[0] = 1;
    @(posedge CLK);
    //in PUSH1
    @(posedge CLK);
    //in PUSH2
    @(posedge CLK);
    //in IDLE

    //reset values
    ccif.iREN = '0;
    ccif.dREN = '0;
    ccif.dWEN = '0;
    ccif.cctrans = '0;
    ccif.ccwrite = '0;

    //go from IDLE to ARBITRATE to WRITEBACKK1 to WRITEBACK2 back to IDLE
    //in IDLE
    assign ccif.dREN[0] = 1;
    @(posedge CLK);
    //in ARBITRATE
    ccif.dWEN[0] = 1;
    @(posedge CLK);
    //in WRITEBACK1
    @(posedge CLK);
    //in WRITEBACK2
    @(posedge CLK);
    //in IDLE

    @(posedge CLK);

  end


endprogram


