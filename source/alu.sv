// Alex Dunker
// adunker@purdue.edu

`include "cpu_types_pkg.vh"
`include "alu_if.vh"

module alu
(
  alu_if.af afif
);

  import cpu_types_pkg::*;

   // always for the logic
   always_comb begin
      afif.port_o <= 0;
      casez(afif.alu_op)
        ALU_SLL : begin
          //shift left logical
          afif.port_o <= afif.port_a << afif.port_b;
        end
        ALU_SRL : begin
           //shift right logical
           afif.port_o <= afif.port_a >> afif.port_b;    
        end
        ALU_ADD : begin
           //signed add
           afif.port_o <= afif.port_a + afif.port_b;     
        end
        ALU_SUB : begin
           //signed subtract
           afif.port_o <= afif.port_a - afif.port_b;     
        end
        ALU_AND : begin
           //logical and
           afif.port_o <= afif.port_a & afif.port_b;     
        end
        ALU_OR : begin
           //logical or
           afif.port_o <= afif.port_a | afif.port_b;     
        end
        ALU_XOR : begin
           //logical xor
           afif.port_o <= afif.port_a ^ afif.port_b;     
        end
        ALU_NOR : begin
           //logical nor
           afif.port_o <= ~ (afif.port_a | afif.port_b);     
        end
        ALU_SLT : begin
           //set less than signed
           afif.port_o <= $signed(afif.port_a) < $signed(afif.port_b);     
        end
        ALU_SLTU : begin
           //set less than unsigned
           afif.port_o <= afif.port_a < afif.port_b;     
        end
      endcase      
   end // always_comb

   //always for the flags
   always_comb begin
      afif.n_fl <= 0;
      afif.z_fl <= 0;
      afif.v_fl <= 0;

      // Overflow logic
      casez(afif.alu_op)
        ALU_ADD : begin
                 if ( (afif.port_a[31] && afif.port_b[31] && ~afif.port_o[31]) | (~afif.port_a[31] && ~afif.port_b[31] && afif.port_o[31]) ) begin
                    afif.v_fl <= 1'b1;
                 end else begin
                    afif.v_fl <= 1'b0;
                 end
        end
        ALU_SUB : begin
           //signed integer overflow occurs if and only if a and b have opposite signs, and the output sign is opposite of a
           if (afif.port_a[31] != afif.port_b[31]) begin
              if (afif.port_o[31] != afif.port_a[31]) begin
             afif.v_fl <= 1'b1;
              end else begin
             afif.v_fl <= 1'b0;
              end
           end else begin
              afif.v_fl <= 1'b0;
           end
        end // case: ALU_SUB
        default : begin
           afif.v_fl <= 1'b0;
        end
      endcase // casez (afif.alu_op)

      // Zero logic
      if (afif.port_o == 0) begin
         afif.z_fl <= 1'b1;
      end else begin
         afif.z_fl <= 1'b0;
      end

      // Negative Logic
      afif.n_fl <= afif.port_o[31];
      
   end  
   
endmodule // alu