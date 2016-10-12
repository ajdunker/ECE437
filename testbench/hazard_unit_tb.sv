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
  datapath_cache_if dpif();
  forwarding_unit_if fuif();
  pipeline_memory_if pmif();
  pipeline_execute_if peif();
  
  // test program
  test PROG (CLK, nRST, huif, pfif, pdif, fuif);
  //pipeline_fetch PF (CLK, nRST, pfif, huif);
  //pipeline_decode PD (CLK, nRST, pfif, pdif, huif);
  forwarding_unit FU (CLK, nRST, fuif, peif, pdif, pmif);
  hazard_unit HU (CLK, nRST, huif, pfif, pdif, dpif);

endmodule

program test(
  input logic CLK, 
  output logic nRST,
  hazard_unit_if huif,
  pipeline_fetch_if pfif,
  pipeline_decode_if pdif,
  forwarding_unit_if fuif
);

  parameter PERIOD = 10;

  initial begin
    // Test Code
    @(posedge CLK);

    nRST = 1'b0;

    @(posedge CLK);

    nRST = 1'b1;

    assign pdif.ID_mem2reg_OUT = 1;

    assign pdif.ID_Instr_OUT[20:16] = 5'b11011;  

    assign pfif.IF_Instr_OUT[25:21] = 5'b11011;
    assign pfif.IF_Instr_OUT[20:16] = 5'b00111;

    /*dpif.ihit = 1;
    pfif.flush = 0;

    @(posedge CLK);

    //ori $1, $zero, 0xF0
    pfif.IF_Instr_IN = 32'h340100F0;

    @(posedge CLK); 

    //ori $2, $zero, 0x02
    pfif.IF_Instr_IN = 32'h34020002;

    @(posedge CLK); 

    //add $3, $1, $2
    pfif.IF_Instr_IN = 32'h00221820;

    @(posedge CLK);

    //add $4, $3, $1
    pfif.IF_Instr_IN = 32'h00612020;

    @(posedge CLK);

    //halt
    pfif.IF_Instr_IN = 32'hFFFFFFFF;*/

    @(posedge CLK);
    @(posedge CLK);

  end


endprogram
