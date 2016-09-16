// Alex Dunker
// adunker@purdue.edu

// INTERFACES
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  // PC & Next PC
  word_t pc, next_pc;

  // immediates
  word_t signedExtImm, zeroExtImm, luiImm, shamt;

  //jump options
  word_t pc4, pc_jump, next_pc_reg, next_pc_br;

  //interfaces
  control_unit_if cuif();
  request_unit_if mrif();
  register_file_if rfif();
  alu_if alif();

  //DUT
  control_unit CU (cuif);
  request_unit MR (CLK, nRST, mrif);
  register_file RF (CLK, nRST, rfif);
  alu ALU (alif);


  /************************************************
                Program Counter Work
  ************************************************/
  logic pcEN;
  assign pcEN = dpif.ihit & (~dpif.dhit);

  always_ff @(posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      pc <= 0;
    end
    else begin
      if (pcEN) begin
         pc <= next_pc;
      end
    end
  end

  /************************************************
                      PC / JUMP
  ************************************************/

  assign pc4 = pc + 4;
  assign pc_jump = {pc4[31:28], dpif.imemload[25:0], 2'b00};
  // next pc for reg jump
  assign next_pc_reg = rfif.rdat1;
  // next pc for branch
  assign next_pc_br = (signedExtImm << 2) + pc4;


  /************************************************
                    Register Wiring
  ************************************************/
  assign signedExtImm = (dpif.imemload[15] == 0) ? {16'h0000, dpif.imemload[15:0]} : {16'hffff, dpif.imemload[15:0]};
  assign zeroExtImm = {16'h0000, dpif.imemload[15:0]};
  assign luiImm = {dpif.imemload[15:0], 16'h0000};
  assign shamt = {24'h000000, 3'b000, dpif.imemload[10:6]};

  /************************************************
                  Control Wiring
  ************************************************/
  assign cuif.Instr = dpif.imemload;

  /************************************************
                    Request Unit
  * ***********************************************/
  assign mrif.mem2reg = cuif.mem2reg;
  assign mrif.MemWrite = cuif.MemWrite;
  assign mrif.dhit = dpif.dhit;
  assign mrif.ihit = dpif.ihit;

  /************************************************
                  Register Wiring
  * ***********************************************/
  // Write enable is dependent on the status of hit signals
  assign rfif.WEN = cuif.mem2reg ? ((dpif.dhit) ? cuif.RegWen : 0) : cuif.RegWen & (dpif.dhit | dpif.ihit);
  // Write select determined the register destination
  assign rfif.wsel = (cuif.RegDest == 2'b00) ? dpif.imemload[15:11] : ((cuif.RegDest == 2'b01) ? dpif.imemload[20:16] : 5'b11111);
  assign rfif.rsel1 = dpif.imemload[25:21];
  assign rfif.rsel2 = dpif.imemload[20:16];
  // Check if we're putting program counter into Register
  assign rfif.wdat = cuif.pc2reg ? pc4 : ((cuif.mem2reg == 1) ? dpif.dmemload : alif.port_o);

  /************************************************
                  ALU Wiring
  * ***********************************************/
  assign alif.alu_op = cuif.alu_op;
  assign alif.port_a = rfif.rdat1;
  assign alif.port_b = (cuif.ALUsrc == 3'b000) ? rfif.rdat2 : ((cuif.ALUsrc == 3'b001) ? signedExtImm : ((cuif.ALUsrc == 3'b010) ? zeroExtImm : (cuif.ALUsrc == 3'b011) ? luiImm : shamt));

  /************************************************
                        Halt Logic
  * ***********************************************/
  logic halt_ff1;
  logic halt_ff;

  always_ff @(posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      halt_ff1 <= 0;
    end else begin
      halt_ff1 <= halt_ff;
    end
  end

  assign halt_ff = (cuif.careOF == 1) ? ((alif.v_fl == 1) ? 1 : 0) : cuif.halt;

  /************************************************
                  DPIF Wiring
  * ***********************************************/
  assign dpif.halt = halt_ff1;
  assign dpif.imemREN = 1;
  assign dpif.imemaddr = pc;
  assign dpif.dmemREN = mrif.dmemREN;
  assign dpif.dmemWEN = mrif.dmemWEN;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr = alif.port_o;


  /************************************************
                        Jump Logic
  * ***********************************************/
  always_comb begin
    next_pc = 0;
    case(cuif.jump_t)
      0 : begin                     //Normal
        next_pc = pc4;
      end
      1 : begin                     //jump to addr
        next_pc = pc_jump;
      end
      2 : begin
        next_pc = next_pc_reg;      //jump to reg
      end
      3 : begin                     //beq
        if (alif.z_fl == 1) begin
          next_pc = next_pc_br;
        end else begin
          next_pc = pc4;
        end
      end
      4 : begin                     //bne
        if (alif.z_fl != 1) begin
          next_pc = next_pc_br;
        end else begin
          next_pc = pc4;
        end
      end
    endcase // cuif.jump_t

  end

endmodule
