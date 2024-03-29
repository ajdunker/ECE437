// Alex Dunker
// adunker@purdue.edu

// interface
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

module alu_fpga (
  //input logic CLOCK_50,
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [2:0] LEDR,
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
);

import cpu_types_pkg::*;
regbits_t regb;

// interface
alu_if aluif();
// alu file
alu AF(aluif);

//Register B
always_ff @ (SW[17]) begin
  if (SW[17])
    regb <= {15'b000000000000000,SW[16:0]};
end

//Input port assignments
assign aluif.port_b = regb;
assign aluif.port_a = {15'b000000000000000,SW[16:0]};

//ALU OP code assignment
assign aluif.alu_op[0] = !KEY[0];
assign aluif.alu_op[1] = !KEY[1];
assign aluif.alu_op[2] = !KEY[2];
assign aluif.alu_op[3] = !KEY[3];

//Flag assignments
assign LEDR[2] = aluif.v_fl;
assign LEDR[1] = aluif.n_fl;
assign LEDR[0] = aluif.z_fl;

//7 Segment Mapping / Output port assignments
always_comb begin
  case (aluif.port_o[3:0])
    'h0: HEX0 = 7'b1000000;
    'h1: HEX0 = 7'b1111001;
    'h2: HEX0 = 7'b0100100;
    'h3: HEX0 = 7'b0110000;
    'h4: HEX0 = 7'b0011001;
    'h5: HEX0 = 7'b0010010;
    'h6: HEX0 = 7'b0000010;
    'h7: HEX0 = 7'b1111000;
    'h8: HEX0 = 7'b0000000;
    'h9: HEX0 = 7'b0010000;
    'ha: HEX0 = 7'b0001000;
    'hb: HEX0 = 7'b0000011;
    'hc: HEX0 = 7'b0100111;
    'hd: HEX0 = 7'b0100001;
    'he: HEX0 = 7'b0000110;
    'hf: HEX0 = 7'b0001110;
  endcase

  case (aluif.port_o[7:4])
    'h0: HEX1 = 7'b1000000;
    'h1: HEX1 = 7'b1111001;
    'h2: HEX1 = 7'b0100100;
    'h3: HEX1 = 7'b0110000;
    'h4: HEX1 = 7'b0011001;
    'h5: HEX1 = 7'b0010010;
    'h6: HEX1 = 7'b0000010;
    'h7: HEX1 = 7'b1111000;
    'h8: HEX1 = 7'b0000000;
    'h9: HEX1 = 7'b0010000;
    'ha: HEX1 = 7'b0001000;
    'hb: HEX1 = 7'b0000011;
    'hc: HEX1 = 7'b0100111;
    'hd: HEX1 = 7'b0100001;
    'he: HEX1 = 7'b0000110;
    'hf: HEX1 = 7'b0001110;
  endcase

  case (aluif.port_o[11:8])
    'h0: HEX2 = 7'b1000000;
    'h1: HEX2 = 7'b1111001;
    'h2: HEX2 = 7'b0100100;
    'h3: HEX2 = 7'b0110000;
    'h4: HEX2 = 7'b0011001;
    'h5: HEX2 = 7'b0010010;
    'h6: HEX2 = 7'b0000010;
    'h7: HEX2 = 7'b1111000;
    'h8: HEX2 = 7'b0000000;
    'h9: HEX2 = 7'b0010000;
    'ha: HEX2 = 7'b0001000;
    'hb: HEX2 = 7'b0000011;
    'hc: HEX2 = 7'b0100111;
    'hd: HEX2 = 7'b0100001;
    'he: HEX2 = 7'b0000110;
    'hf: HEX2 = 7'b0001110;
  endcase

  case (aluif.port_o[15:12])
    'h0: HEX3 = 7'b1000000;
    'h1: HEX3 = 7'b1111001;
    'h2: HEX3 = 7'b0100100;
    'h3: HEX3 = 7'b0110000;
    'h4: HEX3 = 7'b0011001;
    'h5: HEX3 = 7'b0010010;
    'h6: HEX3 = 7'b0000010;
    'h7: HEX3 = 7'b1111000;
    'h8: HEX3 = 7'b0000000;
    'h9: HEX3 = 7'b0010000;
    'ha: HEX3 = 7'b0001000;
    'hb: HEX3 = 7'b0000011;
    'hc: HEX3 = 7'b0100111;
    'hd: HEX3 = 7'b0100001;
    'he: HEX3 = 7'b0000110;
    'hf: HEX3 = 7'b0001110;
  endcase

  case (aluif.port_o[19:16])
    'h0: HEX4 = 7'b1000000;
    'h1: HEX4 = 7'b1111001;
    'h2: HEX4 = 7'b0100100;
    'h3: HEX4 = 7'b0110000;
    'h4: HEX4 = 7'b0011001;
    'h5: HEX4 = 7'b0010010;
    'h6: HEX4 = 7'b0000010;
    'h7: HEX4 = 7'b1111000;
    'h8: HEX4 = 7'b0000000;
    'h9: HEX4 = 7'b0010000;
    'ha: HEX4 = 7'b0001000;
    'hb: HEX4 = 7'b0000011;
    'hc: HEX4 = 7'b0100111;
    'hd: HEX4 = 7'b0100001;
    'he: HEX4 = 7'b0000110;
    'hf: HEX4 = 7'b0001110;
  endcase

  case (aluif.port_o[23:20])
    'h0: HEX5 = 7'b1000000;
    'h1: HEX5 = 7'b1111001;
    'h2: HEX5 = 7'b0100100;
    'h3: HEX5 = 7'b0110000;
    'h4: HEX5 = 7'b0011001;
    'h5: HEX5 = 7'b0010010;
    'h6: HEX5 = 7'b0000010;
    'h7: HEX5 = 7'b1111000;
    'h8: HEX5 = 7'b0000000;
    'h9: HEX5 = 7'b0010000;
    'ha: HEX5 = 7'b0001000;
    'hb: HEX5 = 7'b0000011;
    'hc: HEX5 = 7'b0100111;
    'hd: HEX5 = 7'b0100001;
    'he: HEX5 = 7'b0000110;
    'hf: HEX5 = 7'b0001110;
  endcase

  case (aluif.port_o[27:24])
    'h0: HEX6 = 7'b1000000;
    'h1: HEX6 = 7'b1111001;
    'h2: HEX6 = 7'b0100100;
    'h3: HEX6 = 7'b0110000;
    'h4: HEX6 = 7'b0011001;
    'h5: HEX6 = 7'b0010010;
    'h6: HEX6 = 7'b0000010;
    'h7: HEX6 = 7'b1111000;
    'h8: HEX6 = 7'b0000000;
    'h9: HEX6 = 7'b0010000;
    'ha: HEX6 = 7'b0001000;
    'hb: HEX6 = 7'b0000011;
    'hc: HEX6 = 7'b0100111;
    'hd: HEX6 = 7'b0100001;
    'he: HEX6 = 7'b0000110;
    'hf: HEX6 = 7'b0001110;
  endcase

  case (aluif.port_o[31:28])
    'h0: HEX7 = 7'b1000000;
    'h1: HEX7 = 7'b1111001;
    'h2: HEX7 = 7'b0100100;
    'h3: HEX7 = 7'b0110000;
    'h4: HEX7 = 7'b0011001;
    'h5: HEX7 = 7'b0010010;
    'h6: HEX7 = 7'b0000010;
    'h7: HEX7 = 7'b1111000;
    'h8: HEX7 = 7'b0000000;
    'h9: HEX7 = 7'b0010000;
    'ha: HEX7 = 7'b0001000;
    'hb: HEX7 = 7'b0000011;
    'hc: HEX7 = 7'b0100111;
    'hd: HEX7 = 7'b0100001;
    'he: HEX7 = 7'b0000110;
    'hf: HEX7 = 7'b0001110;
  endcase
end

endmodule
