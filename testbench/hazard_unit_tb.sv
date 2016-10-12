/*

  Alex Dunker
  Mitch Bouma

  adunker@purdue.edu
  mbouma@purdue.edu

  hazard unit test bench
*/

// mapped needs this
`include "hazard_unit_if.vh"

`include "pipeline_fetch_if.vh"
`include "pipeline_decode_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  hazard_unit_if huif();
  pipeline_fetch_if pfif();
  pipeline_decode_if pdif();
  // test program
  test PROG (CLK, nRST, huif, pfif, pdif);

  pipeline_fetch PF (CLK, nRST, pfif, huif);
  pipeline_decode PD (CLK, nRST, pfif, pdif, huif);

  hazard_unit HU (CLK, nRST, huif, pfif, pdif);

endmodule

program test(
  input logic CLK, 
  output logic nRST,
  hazard_unit_if huif,
  pipeline_fetch_if pfif,
  pipeline_decode_if pdif
);

  parameter PERIOD = 10;

  initial begin
    // Test Code
    @(posedge CLK);

    nRST = 1'b0;
    @(posedge CLK);
    nRST = 1'b1;

    @(posedge CLK);

    //pdif.ID_Instr_IN[20:16] = 5;

    pfif.IF_Instr_IN = '1;
    @(posedge CLK);
    @(posedge CLK);
    @(posedge CLK);
    @(posedge CLK);

    pdif.ID_mem2reg_IN = 1;


  end


endprogram
