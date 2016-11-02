// Alex Dunker
// adunker@purdue.edu

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;
  
  //cache outputs
  assign ccif.iload = (ccif.iREN) ? (ccif.ramload) : '0;
  assign ccif.dload = (ccif.ramload);
  // Wait for access
  assign ccif.iwait = (ccif.ramstate == ACCESS) ? (((ccif.iREN == 1) && (ccif.dWEN != 1) && (ccif.dREN != 1)) ? 0 : 1):1;
  assign ccif.dwait = (ccif.ramstate == ACCESS) ? ((ccif.dREN)? 0 : ((ccif.dWEN) ? 0 : 1)):1;

  //r am outputs
  assign ccif.ramWEN = ccif.dWEN;
  assign ccif.ramREN = (((ccif.dREN == 1) || (ccif.iREN == 1))&&(ccif.dWEN != 1)) ? 1 : 0;
  assign ccif.ramstore = ccif.dstore;
  assign ccif.ramaddr = ((ccif.dREN == 1) || (ccif.dWEN == 1)) ? ccif.daddr : ccif.iaddr;


  typedef enum {IDLE, FETCH, ARBITRATE, WRITEBACK1, WRITEBACK2, SNOOP, LOAD1, LOAD2, PUSH1, PUSH2} state_type;

  state_type state, n_state;

  logic cpuid, n_cpuid;

  always_ff @ (posedge CLK, negedge nRST) begin
    if(!nRST) begin
      state <= IDLE;
      cpuid <= 0;
    end else begin
      state <= n_state;
      cpuid <= n_cpuid;
    end
  end

  //assign ccif.ccsnoopaddr[~cpuid] = ccif.daddr[cpuid];

  always_comb begin
    ccif.ccsnoopaddr[~cpuid] = ccif.daddr[cpuid];
    n_cpuid = cpuid;

    ccif.ccinv = '0;  ccif.ccwait = '0;
    ccif.dwait = '1;  ccif.iwait = '1;
    ccif.dload = '0;  ccif.iload = '0;
    ccif.ramstore = '0;
    ccif.ramaddr = '0;
    ccif.ramWEN = '0;
    ccif.ramREN = '0;

    casez(state)

      IDLE : begin
        if (ccif.iREN) begin
          n_state = FETCH;
        end else if (ccif.dWEN || ccif.dREN) begin
          n_state = ARBITRATE;
          if (ccif.dWEN[1] || ccif.dREN[1]) begin
            n_cpuid = 1;
          end else begin
            n_cpuid = 0;
          end
        end
      end

      FETCH : begin
        ccif.iwait[cpuid] = 0;
        ccif.ramaddr[cpuid] = ccif.iaddr[cpuid];
        ccif.ramREN[cpuid] = 1;
        n_state = IDLE; 
      end

      ARBITRATE : begin
        if(ccif.dWEN[cpuid]) begin
          n_state = WRITEBACK1;
        end else if (ccif.dREN[cpuid]) begin
          n_state = SNOOP;
        end else begin
          n_state = ARBITRATE;
        end
      end

      SNOOP : begin
        ccif.ccwait[~cpuid] = 1;

        if (ccif.cctrans[~cpuid] && ccif.ccwrite[~cpuid]) begin
          n_state = LOAD1;
        end else if (!ccif.cctrans[~cpuid] && ccif.ccwrite[~cpuid]) begin
          n_state = PUSH1;
        end else begin
          n_state = SNOOP;
        end
      end

      LOAD1 : begin
        ccif.dwait[cpuid] = 0;
        n_state = LOAD2;
      end

      LOAD2 : begin
        ccif.dwait[cpuid] = 0;
        n_state = IDLE;
      end

      PUSH1 : begin
        ccif.dwait[cpuid] = 0;
        ccif.ccinv[~cpuid] = 1;
        n_state = PUSH2;
      end

      PUSH2 : begin
        ccif.dwait[cpuid] = 0;
        ccif.ccinv[~cpuid] = 1;
        n_state = IDLE;
      end

      WRITEBACK1 : begin
        ccif.dwait[cpuid] = 0;
        n_state = WRITEBACK2;
      end

      WRITEBACK2 : begin
        ccif.dwait[cpuid] = 0;
        n_state = IDLE;
      end
    endcase
  end
endmodule

//read value that is snooped
