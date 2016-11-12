/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"
 // type import
  import cpu_types_pkg::*;

module memory_control (
  input logic CLK, nRST,
  input word_t dmemaddr0,
  input word_t dmemaddr1,
  cache_control_if ccif
);
 
  
  // number of cpus for cc
  //parameter CPUS = 2;

  logic [1:0] _snoopingTag;
  logic _snoopchecking0;
  logic _snoopchecking1;

  assign _snoopchecking0 = ccif.ccsnoopchecking[0];
  assign _snoopchecking1 = ccif.ccsnoopchecking[1];

  coherency_control COC (CLK, nRST, _snoopchecking0, _snoopchecking1,ccif, _snoopingTag);

  logic i_server;
  logic n_i_server;

  always_ff @ (posedge CLK, negedge nRST)
  begin
    if(!nRST)
    begin
      i_server <= 0;
    end
    else 
    begin
      i_server <= n_i_server;  
    end
  end

  //ram outputs
  /*assign ccif.ramstore = ccif.dstore[1];
  assign ccif.ramaddr = ((ccif.dREN[1] == 1) || (ccif.dWEN[1] == 1)) ? ccif.daddr[1] : ccif.iaddr[1];
  assign ccif.ramWEN = ccif.dWEN[1];
  assign ccif.ramREN = (((ccif.dREN[1] == 1) || (ccif.iREN[1] == 1))&&(ccif.dWEN[1] != 1)) ? 1 : 0; //not sure
  
  //cache outputs
  assign ccif.iload[1] = (ccif.iREN[1]) ? (ccif.ramload) : '0; //'not sure
  assign ccif.dload[1] = (ccif.ramload); //not sure
  assign ccif.iwait[1] = (ccif.ramstate == ACCESS) ? (((ccif.iREN[1] == 1) && (ccif.dWEN[1] != 1) && (ccif.dREN[1] != 1)) ? 0 : 1):1;
  assign ccif.dwait[1] = (ccif.ramstate == ACCESS) ? ((ccif.dREN[1])? 0 : ((ccif.dWEN[1]) ? 0 : 1)):1;*/

  typedef enum{IDLE, D0Write, D1Write, D0Read, D1Read, I0Read, I1Read} task_type;

  task_type mytask;

  logic dWEN0;
  logic dWEN1;
  logic dREN0;
  logic dREN1;
  logic iREN0;
  logic iREN1;
  assign dWEN0 = ccif.dWEN[0];
  assign dWEN1 = ccif.dWEN[1];
  assign dREN0 = ccif.dREN[0];
  assign dREN1 = ccif.dREN[1];
  assign iREN0 = ccif.iREN[0];
  assign iREN1 = ccif.iREN[1];

  

  always_comb 
  begin
    mytask = IDLE;

    if (_snoopingTag == 2'b00)
    begin
      if (dWEN0)
      begin
        mytask = D0Write;
      end
      else if (dREN0)
      begin
        mytask = D0Read;
      end
      else 
      begin
        mytask = IDLE;  
      end
    end
    else if (_snoopingTag == 2'b01)
    begin
      if (dWEN1)
      begin
        mytask = D1Write;
      end
      else if (dREN1)
      begin
        mytask = D1Read;
      end
      else 
      begin
        mytask = IDLE;
      end
    end
    else 
    begin
      if (dWEN0)
      begin
        mytask = D0Write;
      end
      else if (dWEN1)
      begin
        mytask = D1Write;
      end
      else if (dREN0)
      begin
        mytask = D0Read;
      end
      else if (dREN1)
      begin
        mytask = D1Read;
      end
      else 
      begin
        //do instruction loading
        if(iREN0&&iREN1)
        begin
          if (i_server == 2'b00)
          begin
            if (iREN0 == 1)
            begin
              mytask = I0Read;
            end
            else 
            begin
              mytask = IDLE;
            end
          end
          else
          begin
            if (iREN1 == 1)
            begin
              mytask = I1Read;
            end
            else 
            begin
              mytask = IDLE;
            end
          end  
        end
        else if (iREN0)
        begin
          mytask = I0Read;
        end
        else if (iREN1)
        begin
          mytask = I1Read;
        end
        else 
        begin
          mytask = IDLE;
        end
        

       /* if (iREN0)
        begin
          mytask = I0Read;
        end
        else if (iREN1)
        begin
          mytask = I1Read;
        end
        else 
        begin
          mytask = IDLE;
        end*/
      end
    end
  end

  logic ramWEN;
  logic ramREN;
  word_t ramstore;
  word_t ramaddr;

  assign ccif.ramWEN = ramWEN;
  assign ccif.ramREN = ramREN;
  assign ccif.ramstore = ramstore;
  assign ccif.ramaddr = ramaddr;

  word_t dstore0;
  word_t dstore1;
  word_t daddr0;
  word_t daddr1;
  word_t iaddr0;
  word_t iaddr1;
  assign dstore0 = ccif.dstore[0];
  assign dstore1 = ccif.dstore[1];
  assign daddr0 = ccif.daddr[0];
  assign daddr1 = ccif.daddr[1];
  assign iaddr0 = ccif.iaddr[0];
  assign iaddr1 = ccif.iaddr[1];


  logic iwait0;
  logic iwait1;
  logic dwait0;
  logic dwait1;
  word_t iload0;
  word_t iload1;
  word_t dload0;
  word_t dload1;

  assign ccif.iwait[0] = iwait0;
  assign ccif.iwait[1] = iwait1;
  assign ccif.dwait[0] = dwait0;
  assign ccif.dwait[1] = dwait1;
  assign ccif.iload[0] = iload0;
  assign ccif.iload[1] = iload1;
  assign ccif.dload[0] = dload0;
  assign ccif.dload[1] = dload1;

  logic ccsnoopvalid0;
  logic ccsnoopvalid1;
  assign ccsnoopvalid0 = ccif.ccsnoopvalid[0];
  assign ccsnoopvalid1 = ccif.ccsnoopvalid[1];

  always_comb
  begin
    ramstore = 0;
    ramaddr = 0;
    ramWEN = 0;
    ramREN = 0;

    iload0 = 32'hBAD1BAD1;
    iload1 = 32'hBAD1BAD1;
    dload0 = 32'hBAD1BAD1;
    dload1 = 32'hBAD1BAD1;
   
   iwait0 = 1;
   iwait1 = 1;
   dwait0 = 1;
   dwait1 = 1;

   n_i_server = i_server;

    unique casez (mytask)
      IDLE:
      begin
        
      end

      D0Write:
      begin
        ramstore = dstore0;
        ramaddr = daddr0;
        ramWEN = 1;
        ramREN = 0;

        //dload0 = ccif.ramload;
        if (ccif.ramstate == ACCESS)
        begin
          //ccif.dwait[0] = 0;
          dwait0 = 0;
        end
      end

      D0Read:
      begin
        ramaddr = daddr0;

        if (ccsnoopvalid1&&daddr0 == ccif.ccsnoopaddr[1])
        begin
          //ccif.dwait[0] = 0;
          dwait0 = 0;
          dload0 = ccif.ccsnoopvalue[1];
        end
        else 
        begin
          ramWEN = 0;
          ramREN = 1;
          dload0 = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            //ccif.dwait[0] = 0;
            dwait0 = 0;
          end
        end
      end

      D1Write:
      begin
        ramstore = dstore1;
        ramaddr = daddr1;
        ramWEN = 1;
        ramREN = 0;

        //dload1 = ccif.ramload;
        if (ccif.ramstate == ACCESS)
        begin
          //ccif.dwait[1] = 0;
          dwait1 = 0;
        end
      end

      D1Read:
      begin
        ramaddr = daddr1;

        if (ccsnoopvalid0&&daddr1 == ccif.ccsnoopaddr[0])
        begin
          //ccif.dwait[1] = 0;
          dwait1 = 0;
          dload1 = ccif.ccsnoopvalue[0];
        end
        else 
        begin
          ramWEN = 0;
          ramREN = 1;
          dload1 = ccif.ramload;
          if(ccif.ramstate == ACCESS)
          begin
            //ccif.dwait[1] = 0;
            dwait1 = 0;
          end
        end
      end

      I0Read:
      begin
        ramaddr = iaddr0;
        ramWEN = 0;
        ramREN = 1;

        iload0 = ccif.ramload;
        if (ccif.ramstate == ACCESS)
        begin
          //ccif.iwait[0] = 0;
          iwait0 = 0;
          n_i_server = 1;
        end
      end

      I1Read:
      begin
        ramaddr = iaddr1;
        ramWEN = 0;
        ramREN = 1;

        iload1 = ccif.ramload;
        if (ccif.ramstate == ACCESS)
        begin
          //ccif.iwait[1] = 0;
          iwait1 = 0;
          n_i_server = 0;
        end
      end
    endcase
  end

logic ccatomicinvalidating0;
logic ccatomicinvalidating1;
word_t ccatomicaddr0;
word_t ccatomicaddr1;
logic ccatomicinvalidate0;
logic ccatomicinvalidate1;

assign ccatomicinvalidating0 = ccif.ccatomicinvalidating[0];
assign ccatomicinvalidating1 = ccif.ccatomicinvalidating[1];
assign ccatomicaddr0 = ccif.ccatomicaddr[0];
assign ccatomicaddr1 = ccif.ccatomicaddr[1];
assign ccif.ccatomicinvalidate[0] = ccatomicinvalidate0;
assign ccif.ccatomicinvalidate[1] = ccatomicinvalidate1;

always_comb
begin
    ccatomicinvalidate0 = 0;
    ccatomicinvalidate1 = 0;

    if(ccatomicinvalidating0)
    begin
      if(ccatomicaddr1 == dmemaddr0)
      begin
        ccatomicinvalidate1 = 1;
      end
    end
    else if(ccatomicinvalidating1)
    begin
      if(ccatomicaddr0 == dmemaddr1)
      begin
        ccatomicinvalidate0 = 1;
      end
    end
end
  

endmodule
