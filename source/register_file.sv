// Alex Dunker
// adunker@purdue.edu

// interface
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module register_file (
  
  input logic CLK,
  input logic nRST,
  register_file_if.rf rfif
  
  );
  
  word_t [31:0] register;
  
  always_ff @(negedge CLK or negedge nRST)
  begin
    if (!nRST) begin
      register <= '{default:0}; 
    end else if (rfif.WEN == 1) begin
      register[rfif.wsel] <= rfif.wdat;
    end
  end
  
  assign rfif.rdat1 = rfif.rsel1 ? register[rfif.rsel1] : 0;
  assign rfif.rdat2 = rfif.rsel2 ? register[rfif.rsel2] : 0;
  
  endmodule