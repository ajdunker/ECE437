// Alex Dunker
// adunker@purdue.edu

// interface include
`include "control_unit_if.vh"

// memory types
`include "cpu_types_pkg.vh"
 import cpu_types_pkg::*;

module control_unit (
  control_unit_if cuif
);

always_comb
begin

	// Defaults
  	cuif.jump_t = 3'b000; 		//000: def | 001:j to addr | 010 : j to reg | 011 : beq | 100 : bne
  	cuif.RegDest = 2'b00; 		//00 : Rd(0) | 01 : Rt(1) | 10 : 31[10]
  	cuif.RegWen = 0; 			//Register Write Enable
    cuif.ALUsrc = 3'b000; 		//0 : reg | 001 : singed im | 010 : zero im | 011 : lui | 100 : shamt   
  	cuif.alu_op = ALU_SLL;
    cuif.mem2reg = 0; 			//00 : No | 01 : full | 10 : half | 11: byte
    cuif.pc2reg = 0;
    cuif.MemWrite = 0; 			//00 : no | 01 : full | 10 : half | 11: byte
    cuif.careOF = 0;
    cuif.halt = 0;
    cuif.atomic = 1;

	casez(cuif.Instr[31:26])
		/******************************************
			
				R Type Instructions

		******************************************/
		RTYPE:
		begin
			casez(cuif.Instr[5:0])
				SLL : begin
					cuif.alu_op = ALU_SLL;
					cuif.ALUsrc = 3'b100;
					cuif.RegWen = 1;
				end

				SRL : begin
					cuif.alu_op = ALU_SRL;
					cuif.ALUsrc = 3'b100;
					cuif.RegWen = 1;
				end

				JR : begin
					cuif.jump_t = 3'b010;
				end

				ADD : begin
					cuif.alu_op = ALU_ADD;
					cuif.RegWen = 1;
					cuif.careOF = 1;
				end

				ADDU : begin
					cuif.alu_op = ALU_ADD;
					cuif.RegWen = 1;
				end

				SUB : begin
					cuif.alu_op = ALU_SUB;
					cuif.RegWen = 1;
					cuif.careOF = 1;
				end

				SUBU : begin
					cuif.alu_op = ALU_SUB;
					cuif.RegWen = 1;
				end

				AND : begin
					cuif.alu_op = ALU_AND;
					cuif.RegWen = 1;
				end

				OR : begin
					cuif.alu_op = ALU_OR;
					cuif.RegWen = 1;
				end

				XOR : begin
					cuif.alu_op = ALU_XOR;
					cuif.RegWen = 1;
				end

				NOR : begin
					cuif.alu_op = ALU_NOR;
					cuif.RegWen = 1;
				end

				SLT : begin
					cuif.alu_op = ALU_SLT;
					cuif.RegWen = 1;
				end

				SLTU : begin
					cuif.alu_op = ALU_SLTU;
					cuif.RegWen = 1;
				end
			endcase
		end
		/******************************************
			
				J Type Instructions

		******************************************/
		J : begin
			cuif.jump_t = 3'b001;
		end

		JAL : begin
			cuif.jump_t = 3'b001;
			cuif.RegWen = 1'b1;
			cuif.RegDest = 2'b10;
			cuif.pc2reg = 1;
		end

		/******************************************
			
				I Type Instructions

		******************************************/
		BEQ : begin
			cuif.jump_t = 3'b011;
			cuif.alu_op = ALU_SUB;
		end

		BNE : begin
			cuif.jump_t = 3'b100;
			cuif.alu_op = ALU_SUB;
		end

		ADDI : begin
			cuif.alu_op = ALU_ADD;
			cuif.ALUsrc = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
			cuif.careOF = 1;
		end

		ADDIU : begin
			cuif.alu_op = ALU_ADD;
			cuif.ALUsrc = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
		end

		SLTI : begin
			cuif.alu_op = ALU_SLT;
			cuif.ALUsrc = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
		end

		SLTIU : begin
			cuif.alu_op = ALU_SLTU;
			cuif.ALUsrc = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
		end

		ANDI : begin
			cuif.alu_op = ALU_AND;
			cuif.ALUsrc = 3'b010;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
		end

		ORI : begin
			cuif.alu_op = ALU_OR;
			cuif.ALUsrc = 3'b010;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
		end

		XORI : begin
			cuif.alu_op = ALU_XOR;
			cuif.ALUsrc = 3'b010;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
		end

		LUI : begin
			cuif.alu_op = ALU_OR;
			cuif.ALUsrc = 3'b011;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
		end

		LW : begin
			cuif.alu_op = ALU_ADD;
			cuif.ALUsrc = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
			cuif.mem2reg = 1;
		end
		
		SW : begin
			cuif.alu_op = ALU_ADD;
			cuif.ALUsrc = 3'b001;
			cuif.MemWrite = 1;
		end

		LL : begin
			cuif.alu_op = ALU_ADD;
			cuif.ALUsrc = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
			cuif.mem2reg = 1;
			cuif.atomic = 1;
		end

		SC : begin
			cuif.alu_op = ALU_ADD;
			cuif.ALUsrc = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDest = 2'b01;
			cuif.MemWrite = 1;
			cuif.atomic = 1;
		end

		HALT : begin
			cuif.halt = 1;
		end
	endcase
end

endmodule