// Alex Dunker
// adunker@purdue.edu

// INTERFACES
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

`include "pipeline_fetch_if.vh"
`include "pipeline_decode_if.vh"
`include "pipeline_execute_if.vh"
`include "pipeline_memory_if.vh"

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

  pipeline_fetch_if pfif();
  pipeline_decode_if pdif();
  pipeline_execute_if peif();
  pipeline_memory_if pmif();

  //DUT
  control_unit CU (cuif);
  request_unit MR (CLK, nRST, mrif);
  register_file RF (CLK, nRST, rfif);
  alu ALU (alif);

  pipeline_fetch PF (CLK, nRST, pfif);
  pipeline_decode PD (CLK, nRST, pfif, pdif);
  pipeline_execute PE (CLK, nRST, pfif, pdif, peif);
  pipeline_memory PM (CLK, nRST, pfif, pdif, peif, pmif);

  logic branching;

  /************************************************
                Instruction Fetch
  ************************************************/
  assign pfif.IF_Instr_IN = (dpif.ihit) ? dpif.imemload : '0;
  assign pfif.IF_npc_IN = pc4;


  /************************************************
                Program Counter Work
  ************************************************/
  logic pcEN;
  //assign pcEN = dpif.ihit & (~dpif.dhit);

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

  always_comb begin
    pcEN = 0;
    if (branching) begin
      if (dpif.ihit | dpif.dhit) begin
        pcEN = 1;
      end
    end else begin
      pcEN = dpif.ihit & (~dpif.dhit);
    end
  end

  /************************************************
                  Instruction Decode
  ************************************************/

  assign signedExtImm = (pfif.IF_Instr_OUT[15] == 0) ? {16'h0000, pfif.IF_Instr_OUT[15:0]} : {16'hffff, pfif.IF_Instr_OUT[15:0]};
  assign zeroExtImm = {16'h0000, pfif.IF_Instr_OUT[15:0]};
  assign luiImm = {pfif.IF_Instr_OUT[15:0], 16'h0000};
  assign shamt = {24'h000000, 3'b000, pfif.IF_Instr_OUT[10:6]};

  assign pdif.ID_alu_op_IN = cuif.alu_op;
  assign pdif.ID_mem2reg_IN = cuif.mem2reg;
  assign pdif.ID_pc2reg_IN = cuif.pc2reg;
  assign pdif.ID_MemWrite_IN = cuif.MemWrite;
  assign pdif.ID_careOF_IN = cuif.careOF;
  assign pdif.ID_halt_IN = cuif.halt;
  assign pdif.ID_jump_IN = cuif.jump_t;
  assign pdif.ID_RegDest_IN = cuif.RegDest;
  assign pdif.ID_RegWen_IN = cuif.RegWen;
  assign pdif.ID_ALUSrc1_IN = rfif.rdat1;
  assign pdif.ID_ALUSrc2_IN = (cuif.ALUsrc == 3'b000) ? rfif.rdat2 : ((cuif.ALUsrc == 3'b001) ? signedExtImm : ((cuif.ALUsrc == 3'b010) ? zeroExtImm : (cuif.ALUsrc == 3'b011) ? luiImm : shamt));
  assign pdif.ID_rdat2_IN = rfif.rdat2;

  /************************************************
                  Instruction Decode
  ************************************************/
  assign pc4 = pc + 4;
  assign pc_jump = {pc4[31:28], pdif.ID_Instr_OUT[25:0], 2'b00};

  // next pc for reg jump
  //assign next_pc_reg = rfif.rdat1;
  assign next_pc_reg = pdif.ID_ALUSrc1_OUT;
  // next pc for branch
  //assign next_pc_br = (signedExtImm << 2) + pc4;
  logic [31:0] branch_off;
  assign branch_off = (pdif.ID_Instr_OUT[15] == 0) ? {16'h0000, pdif.ID_Instr_OUT[15:0]} : {16'hffff, pdif.ID_Instr_OUT[15:0]};
  assign next_pc_br = (branch_off << 2) + pdif.ID_npc_OUT;

  /************************************************
                        Jump Logic
  * ***********************************************/
  always_comb begin
    next_pc = 0;
    branching = 0;
    case(cuif.jump_t)
      0 : begin                     //Normal
        next_pc = pc4;
      end
      1 : begin                     //jump to addr
        next_pc = pc_jump;
        branching = 1;
      end
      2 : begin
        next_pc = next_pc_reg;      //jump to reg
        branching = 1;
      end
      3 : begin                     //beq
        if (alif.z_fl == 1) begin
          next_pc = next_pc_br;
          branching = 1;
        end else begin
          next_pc = pc4;
        end
      end
      4 : begin                     //bne
        if (alif.z_fl != 1) begin
          next_pc = next_pc_br;
          branching = 1;
        end else begin
          next_pc = pc4;
        end
      end
    endcase // cuif.jump_t

  end

  assign peif.EX_result_IN = (pdif.ID_jump_OUT == 3'b001) ?  pdif.ID_npc_OUT : alif.port_o;
  assign peif.EX_RegDest_IN = (pdif.ID_RegDest_OUT == 2'b00) ? pdif.ID_Instr_OUT[15:11] : ((pdif.ID_RegDest_OUT == 2'b01) ?  pdif.ID_Instr_OUT[20:16] : 5'b11111);

  assign peif.EX_wdat_IN = pdif.ID_rdat2_OUT;

  /************************************************
                  Mem
  ************************************************/
  assign pmif.MEM_rdat_IN = dpif.dmemload;

  /************************************************
                  Control Wiring
  ************************************************/
  //assign cuif.Instr = dpif.imemload;
  assign cuif.Instr = pfif.IF_Instr_OUT;

  /************************************************
                  Register Wiring
  * ***********************************************/
  // Write enable is dependent on the status of hit signals
  //assign rfif.WEN = cuif.mem2reg ? ((dpif.dhit) ? cuif.RegWen : 0) : cuif.RegWen & (dpif.dhit | dpif.ihit);
  assign rfif.WEN = pmif.MEM_mem2reg_OUT ? ( 1 ? pmif.MEM_RegWen_OUT : 0) : pmif.MEM_RegWen_OUT;
  // Write select determined the register destination
  //assign rfif.wsel = (cuif.RegDest == 2'b00) ? dpif.imemload[15:11] : ((cuif.RegDest == 2'b01) ? dpif.imemload[20:16] : 5'b11111);
  //assign rfif.rsel1 = dpif.imemload[25:21];
  //assign rfif.rsel2 = dpif.imemload[20:16];
  assign rfif.wsel = pmif.MEM_RegDest_OUT;
  assign rfif.rsel1 = pfif.IF_Instr_OUT[25:21];
  assign rfif.rsel2 = pfif.IF_Instr_OUT[20:16];
  // Check if we're putting program counter into Register
  //assign rfif.wdat = cuif.pc2reg ? pc4 : ((cuif.mem2reg == 1) ? dpif.dmemload : alif.port_o);
   assign rfif.wdat = (pmif.MEM_mem2reg_OUT == 1) ? pmif.MEM_rdat_OUT : pmif.MEM_result_OUT;

  /************************************************
                  ALU Wiring
  * ***********************************************/
  //assign alif.alu_op = cuif.alu_op;
  assign alif.alu_op = pdif.ID_alu_op_OUT;
  //assign alif.port_a = rfif.rdat1;
  assign alif.port_a = pdif.ID_ALUSrc1_OUT;
  //assign alif.port_b = (cuif.ALUsrc == 3'b000) ? rfif.rdat2 : ((cuif.ALUsrc == 3'b001) ? signedExtImm : ((cuif.ALUsrc == 3'b010) ? zeroExtImm : (cuif.ALUsrc == 3'b011) ? luiImm : shamt));
  assign alif.port_b = pdif.ID_ALUSrc2_OUT;

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
  //assign dpif.dmemREN = mrif.dmemREN;
  //assign dpif.dmemWEN = mrif.dmemWEN;
  //assign dpif.dmemstore = rfif.rdat2;
  //assign dpif.dmemaddr = alif.port_o;
  assign dpif.dmemREN = peif.EX_mem2reg_OUT;
  assign dpif.dmemWEN = peif.EX_MemWrite_OUT;
  assign dpif.dmemstore = peif.EX_wdat_OUT;
  assign dpif.dmemaddr = peif.EX_result_OUT;


endmodule
