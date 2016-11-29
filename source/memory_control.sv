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
  parameter CPUS = 2;
  
  //cache outputs
  //assign ccif.iload = (ccif.iREN) ? (ccif.ramload) : '0;
  //assign ccif.dload = (ccif.ramload);
  // Wait for access
  //assign ccif.iwait = (ccif.ramstate == ACCESS) ? (((ccif.iREN == 1) && (ccif.dWEN != 1) && (ccif.dREN != 1)) ? 0 : 1):1;
  //assign ccif.dwait = (ccif.ramstate == ACCESS) ? ((ccif.dREN)? 0 : ((ccif.dWEN) ? 0 : 1)):1;

  //r am outputs
  //assign ccif.ramWEN = ccif.dWEN;
  //assign ccif.ramREN = (((ccif.dREN == 1) || (ccif.iREN == 1))&&(ccif.dWEN != 1)) ? 1 : 0;
  //assign ccif.ramstore = ccif.dstore;
  //assign ccif.ramaddr = ((ccif.dREN == 1) || (ccif.dWEN == 1)) ? ccif.daddr : ccif.iaddr;


  typedef enum {IDLE, FETCH, WRITEBACK1, WRITEBACK2, SNOOP, SNOOP2, LOAD1, LOAD2, PUSH1, PUSH2, INVALIDATE} state_type;

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

  assign ccif.ccsnoopaddr[0] = ccif.daddr[1];
  assign ccif.ccsnoopaddr[1] = ccif.daddr[0];
  assign ccif.ccinv[0] = ccif.ccwrite[1];
  assign ccif.ccinv[1] = ccif.ccwrite[0];

  always_comb begin
    //ccif.ccsnoopaddr[~cpuid] = ccif.daddr[cpuid];
    //ccif.ccinv[~cpuid] = ccif.ccwrite[cpuid];

    n_cpuid = cpuid;

    //ccif.ccinv = '0;  
    ccif.ccwait = '0;
    ccif.dwait = '1;  
    ccif.iwait = '1;
    ccif.dload = '0;  
    ccif.iload = '0;
    ccif.ramstore = '0;
    ccif.ramaddr = '0;
    ccif.ramWEN = '0;
    ccif.ramREN = '0;

    n_state = IDLE;

    casez(state)
      IDLE : begin
        ccif.ccwait = '0;
        if (ccif.dWEN[0] | ccif.dWEN[1] | ccif.dREN[0] | ccif.dREN[1]) begin
          if (ccif.dWEN[1] || ccif.dREN[1]) begin
            n_cpuid = 1;
          end else begin
            n_cpuid = 0;
          end

          if (ccif.cctrans[n_cpuid] && ccif.dREN[n_cpuid]) begin
            n_state = SNOOP;
          end else if (ccif.cctrans[n_cpuid] && /*!ccif.ccwrite[n_cpuid] &&*/ ccif.dWEN[n_cpuid]) begin
            n_state = WRITEBACK1;
          end else if (ccif.cctrans[n_cpuid] && ccif.ccwrite[n_cpuid] && !ccif.dWEN[n_cpuid] && !ccif.dREN[n_cpuid]) begin
            n_state = INVALIDATE;
          end else begin
            n_state =  IDLE;
          end
        end else if (ccif.iREN[0] || ccif.iREN[1]) begin
          n_state = FETCH;
        end
      end

      FETCH : begin
        ccif.iwait = '1;
        ccif.iload[cpuid] = ccif.ramload;
        ccif.ramaddr = ccif.iaddr[cpuid];
        ccif.ramREN = 1;
        if (ccif.ramstate == ACCESS) begin
          n_state = IDLE;
          if (ccif.iREN[~cpuid]) 
            n_cpuid = ~cpuid;
          ccif.iwait[cpuid] = '0;
        end else begin
          n_state = FETCH;
        end
      end

      SNOOP : begin
        ccif.ccwait[~cpuid] = 1;
        n_state = SNOOP2;
        /*if(ccif.ccwrite[cpuid]) begin
          ccif.ccinv[~cpuid] = 1;
        end*/
      end

      SNOOP2: begin
        ccif.ccwait[~cpuid] = 1;
        /*if(ccif.ccwrite[cpuid]) begin
          ccif.ccinv[~cpuid] = 1;
        end*/
        if (ccif.cctrans[~cpuid] && ccif.ccwrite[~cpuid]) begin
          n_state = PUSH1;
        end else if (ccif.cctrans[~cpuid] && !ccif.ccwrite[~cpuid]) begin
          n_state = LOAD1;
        end else begin
          n_state = LOAD1;
        end
        /*if(ccif.cctrans[!cpuid] && !ccif.ccwrite[!cpuid])
          n_state = LOAD1;
        else if(ccif.cctrans[!cpuid] && ccif.ccwrite[!cpuid])
          n_state = PUSH1;
        else begin
          n_state = SNOOP;
        end*/
      end

      LOAD1 : begin
        ccif.dload[cpuid] = ccif.ramload;
        ccif.ramaddr = ccif.daddr[cpuid];
        ccif.ramREN = 1;
        if (ccif.ramstate == ACCESS) begin
          ccif.dwait[cpuid] = 0;
          n_state = LOAD2;
        end else begin
          n_state = LOAD1;
        end
      end

      LOAD2 : begin
        ccif.dload[cpuid] = ccif.ramload;
        ccif.ramaddr = ccif.daddr[cpuid];
        ccif.ramREN = 1;

        if (ccif.ramstate == ACCESS) begin
          ccif.dwait[cpuid] = 0;
          n_state = IDLE;
        end else begin
          n_state = LOAD2;
        end
      end

      PUSH1 : begin
        ccif.dload[cpuid] = ccif.dstore[~cpuid];
        ccif.ramstore = ccif.dstore[~cpuid];
        ccif.ramaddr = ccif.daddr[~cpuid];
        ccif.ramWEN = 1;  
        ccif.dwait[cpuid] = 0;
        /*if(ccif.ccwrite[cpuid]) begin
          ccif.ccinv[~cpuid] = 1;
        end*/
        if (ccif.ramstate == ACCESS) begin
          
          ccif.dwait[~cpuid] = 0;
          n_state = PUSH2;
        end else begin
          n_state = PUSH1;
        end
      end

      PUSH2 : begin
        ccif.dload[cpuid] = ccif.dstore[~cpuid];
        ccif.ramstore = ccif.dstore[~cpuid];
        ccif.ramaddr = ccif.daddr[~cpuid];
        ccif.ramWEN = 1;
        ccif.dwait[cpuid] = 0;
        if (ccif.ramstate == ACCESS) begin
          //ccif.dwait[cpuid] = 0;
          ccif.dwait[~cpuid] = 0;
          n_state = IDLE;
        end else begin
          n_state = PUSH2;
        end
        /*if(ccif.ccwrite[cpuid]) begin
          ccif.ccinv[~cpuid] = 1;
        end*/
      end

      WRITEBACK1 : begin

        ccif.dload[cpuid] = ccif.ramload;
        ccif.ramstore = ccif.dstore[cpuid];
        ccif.ramaddr = ccif.daddr[cpuid];
        ccif.ramWEN = 1;

        if (ccif.ramstate  == ACCESS) begin
          n_state = WRITEBACK2;
          ccif.dwait[cpuid] = 0;
        end else begin
          n_state = WRITEBACK1;
        end
      end

      WRITEBACK2 : begin

        ccif.dload[cpuid] = ccif.ramload;
        ccif.ramstore = ccif.dstore[cpuid];
        ccif.ramaddr = ccif.daddr[cpuid];
        ccif.ramWEN = 1;
        if (ccif.ramstate  == ACCESS) begin
          n_state = IDLE;
          ccif.dwait[cpuid] = 0;
        end
        else begin
          n_state = WRITEBACK2;
        end
      end

      INVALIDATE : begin
        //ccif.ccinv[~cpuid] = 1;
        n_state = IDLE;
      end

    endcase
  end
endmodule

//read value that is snooped
