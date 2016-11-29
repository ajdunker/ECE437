// Alex Dunker
// adunker@purdue.edu

// INTERFACES
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

`include "pipeline_fetch_if.vh"
`include "pipeline_decode_if.vh"
`include "pipeline_execute_if.vh"
`include "pipeline_memory_if.vh"

`include "hazard_unit_if.vh"
`include "forwarding_unit_if.vh"

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
  register_file_if rfif();
  alu_if alif();

  pipeline_fetch_if pfif();
  pipeline_decode_if pdif();
  pipeline_execute_if peif();
  pipeline_memory_if pmif();

  forwarding_unit_if fuif();
  hazard_unit_if huif();

  //DUT
  control_unit CU (cuif);
  register_file RF (CLK, nRST, rfif);
  alu ALU (alif);

  pipeline_fetch PF (CLK, nRST, dpif.dhit, pfif, huif);
  pipeline_decode PD (CLK, nRST, pfif, pdif, huif);
  pipeline_execute PE (CLK, nRST, pfif, pdif, peif, huif);
  pipeline_memory PM (CLK, nRST, pfif, pdif, peif, pmif, huif);
  forwarding_unit FU (CLK, nRST, fuif, peif, pdif, pmif);
  hazard_unit HU (CLK, nRST, dpif.ihit, dpif.dhit, dpif.dmemREN, dpif.dmemWEN, huif, pfif, pdif);

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

  always_ff @(posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      pc <= PC_INIT;
    end
    else begin
      if (pcEN && ~huif.stall) begin
         pc <= next_pc;
      end
    end
  end

  always_comb begin
    pcEN = 0;
    if ((dpif.ihit && !dpif.dhit) && (dpif.dmemREN || dpif.dmemWEN)) begin
      pcEN = 0;
    end else if (branching) begin
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
  assign pdif.ID_halt_IN = cuif.halt;
  assign pdif.ID_jump_IN = cuif.jump_t;
  assign pdif.ID_RegDest_IN = cuif.RegDest;
  assign pdif.ID_RegWen_IN = cuif.RegWen;
  assign pdif.ID_ALUsrc_IN = cuif.ALUsrc;
  assign pdif.ID_ALUSrc1_IN = rfif.rdat1;
  assign pdif.ID_ALUSrc2_IN = (cuif.ALUsrc == 3'b000) ? rfif.rdat2 : ((cuif.ALUsrc == 3'b001) ? signedExtImm : ((cuif.ALUsrc == 3'b010) ? zeroExtImm : (cuif.ALUsrc == 3'b011) ? luiImm : shamt));
  assign pdif.ID_rdat2_IN = rfif.rdat2;
  assign pdif.ID_careOF_IN = cuif.careOF;
  assign pdif.ID_atomic_IN = cuif.atomic;

  /************************************************
                  Instruction Decode
  ************************************************/
  assign pc4 = pc + 4;
  assign pc_jump = {pc4[31:28], pdif.ID_Instr_OUT[25:0], 2'b00};

  // next pc for reg jump

  // next pc for branch
  logic [31:0] branch_off;
  assign branch_off = (pdif.ID_Instr_OUT[15] == 0) ? {16'h0000, pdif.ID_Instr_OUT[15:0]} : {16'hffff, pdif.ID_Instr_OUT[15:0]};
  assign next_pc_br = (branch_off << 2) + pdif.ID_npc_OUT;

  always_comb begin
    next_pc_reg = pdif.ID_ALUSrc1_OUT;
    casez(fuif.ForwardA)
      0 : begin
        next_pc_reg = pdif.ID_ALUSrc1_OUT;
      end

      1 : begin
        if (pmif.MEM_mem2reg_OUT) begin
          next_pc_reg = pmif.MEM_rdat_OUT;
        end else begin
          next_pc_reg = pmif.MEM_result_OUT;
        end
      end

      2 : begin
        next_pc_reg = peif.EX_result_OUT;
      end
    endcase
  end

  /************************************************
                        Jump Logic
  * ***********************************************/
  assign pfif.flush = (~huif.stall) ? branching : 0;

  always_comb begin
    next_pc = 0;
    branching = 0;
    case(pdif.ID_jump_OUT)
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

  //assign peif.EX_wdat_IN = pdif.ID_rdat2_OUT;

  //******************AFFECTED BY ATOMIC 
  always_comb begin
    peif.EX_wdat_IN = pdif.ID_rdat2_OUT;
    casez(fuif.ForwardB)
      0 : begin
        peif.EX_wdat_IN = pdif.ID_rdat2_OUT;
      end

      1 : begin
        if (pmif.MEM_mem2reg_OUT) begin
          peif.EX_wdat_IN = pmif.MEM_rdat_OUT;
        end else if (dpif.state_atomic == 2'b10) begin
          peif.EX_wdat_IN = plif.MEM_state_atomic_OUT;
        end else begin
          peif.EX_wdat_IN = pmif.MEM_result_OUT;
        end
      end

      2 : begin
        if (dpif.state_atomic == 2'b10) begin
          peif.EX_wdat_IN = plif.MEM_state_atomic_OUT;
        end else begin
          peif.EX_wdat_IN = peif.EX_result_OUT;
        end
      end
    endcase
  end


  /************************************************
                  Mem
  ************************************************/
  assign pmif.MEM_rdat_IN = dpif.dmemload;
  assign pmif.MEM_state_atomic_IN = dpif.state_atomic;

  /************************************************
                  Control Wiring
  ************************************************/
  //assign cuif.Instr = dpif.imemload;
  assign cuif.Instr = pfif.IF_Instr_OUT;

  /************************************************
                  Register Wiring
  * ***********************************************/
  // Write enable is dependent on the status of hit signals
  assign rfif.WEN = pmif.MEM_mem2reg_OUT ? ( 1 ? pmif.MEM_RegWen_OUT : 0) : pmif.MEM_RegWen_OUT;
  // Write select determined the register destination
  assign rfif.wsel = pmif.MEM_RegDest_OUT;
  assign rfif.rsel1 = pfif.IF_Instr_OUT[25:21];
  assign rfif.rsel2 = pfif.IF_Instr_OUT[20:16];

  // Check if we're putting program counter into Register
  //******************AFFECTED BY ATOMIC 
  //assign rfif.wdat = (pmif.MEM_mem2reg_OUT == 1) ? pmif.MEM_rdat_OUT : pmif.MEM_result_OUT;
  assign rfif.wdat = (pmif.MEM_state_atomic_OUT == 2'b10) ? ((pmif.MEM_mem2reg_OUT == 1) ? pmif.MEM_rdat_OUT : pmif.MEM_result_OUT) : pmif.MEM_state_atomic_OUT;

  /************************************************
                  ALU Wiring
  * ***********************************************/
  assign alif.alu_op = pdif.ID_alu_op_OUT;

  always_comb begin
    alif.port_a = pdif.ID_ALUSrc1_OUT;
    alif.port_b = pdif.ID_ALUSrc2_OUT;

    casez(fuif.ForwardA)
      0 : begin
        alif.port_a = pdif.ID_ALUSrc1_OUT;
      end

      //******************AFFECTED BY ATOMIC 
      1 : begin
        if (pmif.MEM_mem2reg_OUT) begin
          alif.port_a = pmif.MEM_rdat_OUT;
        end else if (dpif.state_atomic == 2'b10) begin
          peif.EX_wdat_IN = plif.MEM_state_atomic_OUT;
        end else begin
          alif.port_a = pmif.MEM_result_OUT;
        end
      end

      2 : begin
        alif.port_a = peif.EX_result_OUT;
      end

    endcase

    casez(fuif.ForwardB)
      0 : begin
        alif.port_b = pdif.ID_ALUSrc2_OUT;
      end

      1 : begin
        if (pdif.ID_MemWrite_OUT || pdif.ID_ALUsrc_OUT) begin
          alif.port_b = pdif.ID_ALUSrc2_OUT;
        end else begin
          if (pmif.MEM_mem2reg_OUT) begin
            alif.port_b = pmif.MEM_rdat_OUT;
          end else begin
            alif.port_b = pmif.MEM_result_OUT;
          end
        end
      end

      2 : begin
        if (pdif.ID_MemWrite_OUT) begin
          alif.port_b = pdif.ID_ALUSrc2_OUT;
        end else begin
          alif.port_b = peif.EX_result_OUT;
        end
      end
    endcase
  end

  /************************************************
                        Halt Logic
  * ***********************************************/
  logic halt_ff1;
  logic halt_ff;

  always_ff @(negedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      halt_ff1 <= 0;
    end else begin
      if (pmif.MEM_halt_OUT) begin
        halt_ff1 <= 1;
      end
    end
  end

  //assign halt_ff = (pdif.ID_careOF_OUT == 1) ? ((alif.v_fl == 1) ? 1 : 0) : pmif.MEM_halt_OUT;

  /************************************************
                  DPIF Wiring
  * ***********************************************/
  assign dpif.halt = halt_ff1;
  assign dpif.imemREN = 1;
  assign dpif.imemaddr = pc;

  assign dpif.dmemREN = peif.EX_mem2reg_OUT;
  assign dpif.dmemWEN = peif.EX_MemWrite_OUT;
  assign dpif.dmemstore = peif.EX_wdat_OUT;
  assign dpif.dmemaddr = peif.EX_result_OUT;
  assign dpif.datomic = pmif.EX_atomic_OUT;


endmodule
