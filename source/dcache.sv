// Alex Dunker
// adunker@purdue.edu
//Mitch Bouma
//mbouma@purdue.edu

// dcache

`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module dcache 
(
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if cif
);

	typedef enum {IDLE, ALLOCATE1, ALLOCATE2, WBACK1, WBACK2, FLUSH1, FLUSH2, HIT_CNT, END_FLUSH} state_type;
	state_type state, n_state;

	//92 bits wide, 8 rows, 2 pieces of data per row
	logic [1:0][7:0][91:0] cacheReg;
	logic [1:0][7:0][91:0] n_cacheReg;
	logic [25:0] tag;
	logic [2:0] d_index;
	logic [25:0] tagToCheck0, tagToCheck1;
	logic validCheck0, validCheck1;
	logic dirtyCheck0, dirtyCheck1;
	logic [31:0] d_data_stored_0, d_data_stored_1, d_data_stored;
	logic [1:0] d_same_tag;
	logic [7:0] acc_map, n_acc_map;
	logic [31:0] d_other_addr;
	logic [31:0] hitCount, n_hitCount;
	logic [3:0]  count, n_count;
	logic flushReg, n_flushReg;
	logic test;

	integer i;
	always_ff @(posedge CLK, negedge nRST) begin
	    	if (!nRST) begin
				for (i=0;i<8;i++) begin
					cacheReg[1][i][91:90]<=0;
					cacheReg[0][i][91:90]<=0;
				end
				state <= IDLE;
				acc_map <= '0;
				hitCount <= '0;
				count <= '0;
				flushReg <= '0;
	    	end else begin
				cacheReg <= n_cacheReg;
				state <= n_state;
				acc_map <= n_acc_map;
				hitCount <= n_hitCount;
				count <= n_count;
				flushReg <= n_flushReg;
    		end
	end
 
	always_comb begin
		tag = dcif.dmemaddr[31:6];
		d_index = dcif.dmemaddr[5:3];
		tagToCheck0 = cacheReg[0][d_index][89:64];
		tagToCheck1 = cacheReg[1][d_index][89:64];
		validCheck0 = cacheReg[0][d_index][91];
		validCheck1 = cacheReg[1][d_index][91];
		dirtyCheck0 = cacheReg[0][d_index][90];
		dirtyCheck1 = cacheReg[1][d_index][90];
		dcif.flushed = flushReg;

		if (dcif.dmemaddr[2]) begin
			d_data_stored_0 = cacheReg[0][d_index][63:32];
			d_data_stored_1 = cacheReg[1][d_index][63:32];
		end else begin
			d_data_stored_0 = cacheReg[0][d_index][31:0];
			d_data_stored_1 = cacheReg[1][d_index][31:0];
		end

		if (tag == tagToCheck0) begin
			d_same_tag = 2'b00;
		end else if (tag == tagToCheck1) begin
			d_same_tag = 2'b01;
		end else begin
			d_same_tag = 2'b10;
		end

		if (d_same_tag == 2'b00) begin
			d_data_stored = d_data_stored_0;
		end else begin
			d_data_stored = d_data_stored_1;
		end
	end

	always_comb begin
		n_state = IDLE;
		casez (state)
			IDLE: begin
				if (dcif.dmemREN) begin
					if ((d_same_tag == 2'b00 | d_same_tag == 2'b01) & (validCheck0 | validCheck1)) begin
						n_state = IDLE;
					end else if ((!validCheck0 | !validCheck1 | !dirtyCheck0 | !dirtyCheck1)) begin
						n_state = ALLOCATE1;
					end else if (dcif.halt) begin
						n_state = FLUSH1;
					end else begin
						n_state = WBACK1;
					end
				end else if (dcif.dmemWEN) begin
					if (d_same_tag != 2'b00 & d_same_tag != 2'b01) begin
						if (dcif.halt) begin
							n_state = FLUSH1;
						end else if (!validCheck0 | !validCheck1 | !dirtyCheck0 | !dirtyCheck1) begin
							n_state = ALLOCATE1;
						end else begin
							n_state = WBACK1;
						end
					end
				end else begin
					if(dcif.halt) begin
						n_state = FLUSH1;
					end else begin
						n_state = IDLE;  
					end
				end
			end
			ALLOCATE1: begin
				if (!cif.dwait) begin
					n_state = ALLOCATE2;
				end else begin
					n_state = ALLOCATE1;
				end
			end 
			ALLOCATE2: begin
				if (!cif.dwait) begin
					n_state = IDLE;
				end else begin
					n_state = ALLOCATE2; 
				end
			end
			WBACK1: begin
				if(!cif.dwait) begin
					n_state = WBACK2;
				end else begin
					n_state = WBACK1;  
				end
			end
			WBACK2: begin
				if(!cif.dwait) begin
					n_state = ALLOCATE1;
				end else begin
					n_state = WBACK2;
				end
			end
			FLUSH1: begin
				if ((cacheReg[count[0]][count[3:1]][90]) & !cif.dwait) begin
					n_state = FLUSH2;
				end else if (cacheReg[count[0]][count[3:1]][90]) begin
					n_state = FLUSH1; 
				end else if (count == 15) begin
					n_state = HIT_CNT;
				end else begin
					n_state = FLUSH1; 
				end
			end
			FLUSH2: begin
				if (!cif.dwait & count == 15) begin
					n_state = HIT_CNT;
				end else if (!cif.dwait) begin
					n_state = FLUSH1;
				end else begin
					n_state = FLUSH2;
				end
			end
			HIT_CNT: begin
				if(!cif.dwait) begin
					n_state = END_FLUSH;
				end else begin
					n_state = HIT_CNT;
				end
			end
			END_FLUSH: begin
				n_state = END_FLUSH;
			end
			default: n_state = IDLE;
		endcase
	end

	always_comb begin
		n_cacheReg = cacheReg;
		dcif.dmemload = 0;
		dcif.dhit = 0;
		cif.dREN = 0;
		cif.dWEN = 0;
		cif.daddr = dcif.dmemaddr;
		cif.dstore = 0;
		d_other_addr = dcif.dmemaddr;
		n_acc_map = acc_map;
		n_hitCount = hitCount;
		n_count = count;
		n_flushReg = 0;

		casez (state)
			IDLE : begin
				if(dcif.dmemREN) begin
					if(d_same_tag != 2'b10) begin
						if (d_same_tag == 2'b00 && validCheck0 == 1) begin 
							dcif.dhit = 1;
							n_hitCount = hitCount + 1; //add to hit counter
							dcif.dmemload = d_data_stored;
							n_acc_map[d_index] = 1;                                             
						end else if (validCheck1 == 1 && d_same_tag == 2'b01) begin 
							dcif.dhit = 1;
							n_hitCount=hitCount + 1; //add to hit counter
							dcif.dmemload = d_data_stored;
							n_acc_map[d_index] = 0;
						end else begin
							if ((!validCheck0) || (!validCheck1)) begin
								if (!validCheck0) begin
									n_acc_map[d_index] = 0;
								end else begin
									n_acc_map[d_index] = 1;
								end
							end else if((!dirtyCheck0) || (!dirtyCheck1)) begin
								if(!dirtyCheck0) begin
									n_acc_map[d_index] = 0; 
								end else begin
									n_acc_map[d_index] = 1;
								end
							end
						end
					end else begin
						if((!validCheck0) || (!validCheck1)) begin
							if (!validCheck0) begin
								n_acc_map[d_index] = 0;
							end else begin
								n_acc_map[d_index] = 1;
							end
						end else if((!dirtyCheck0) || (!dirtyCheck1)) begin
							if(!dirtyCheck0) begin
								n_acc_map[d_index] = 0;
							end else begin
								n_acc_map[d_index] = 1;
							end
						end
					end
				end else if (dcif.dmemWEN) begin
					if (d_same_tag == 2'b00) begin
						dcif.dhit = 1;
						if(validCheck0==1) begin
							n_hitCount=hitCount + 1; //add to hit counter
						end
						if(acc_map[d_index] == d_same_tag) begin
							n_acc_map[d_index]=acc_map[d_index]+1;
						end
						n_cacheReg[0][d_index][90] = 1;
						n_cacheReg[0][d_index][91] = 1;
						if (dcif.dmemaddr[2] == 1) begin
							n_cacheReg[0][d_index][63:32] = dcif.dmemstore;
						end else begin
							n_cacheReg[0][d_index][31:0] = dcif.dmemstore;  
						end
					end else if (d_same_tag == 2'b01) begin
						dcif.dhit = 1;

						if(validCheck1==1) begin
							n_hitCount=hitCount + 1; //add to hit counter
						end

						if(acc_map[d_index] == d_same_tag) begin
							n_acc_map[d_index]=acc_map[d_index]+1;
						end

						n_cacheReg[1][d_index][90] = 1;
						n_cacheReg[1][d_index][91] = 1;

						if(dcif.dmemaddr[2] == 1) begin
							n_cacheReg[1][d_index][63:32] = dcif.dmemstore;
						end else begin
							n_cacheReg[1][d_index][31:0] = dcif.dmemstore;
						end
					end else begin
						if(!validCheck0) begin
							n_acc_map[d_index] = 0;
						end else if(!validCheck1) begin
							n_acc_map[d_index] = 1;
						end else if(!dirtyCheck0) begin
							n_acc_map[d_index] = 0;
						end else if (!dirtyCheck1) begin
							n_acc_map[d_index] = 1;
						end	
					end
				end
			end

			ALLOCATE1 : begin
				cif.dREN = 1;
				cif.daddr = dcif.dmemaddr;

				n_cacheReg[acc_map[d_index]][d_index][89:64] = dcif.dmemaddr[31:6];
				n_cacheReg[acc_map[d_index]][d_index][91] = 1;

				if(!cif.dwait) begin
					if(dcif.dmemaddr[2]) begin
						n_cacheReg[acc_map[d_index]][d_index][63:32] = cif.dload;
					end else begin
						n_cacheReg[acc_map[d_index]][d_index][31:0] = cif.dload;
					end
				end
			end

			ALLOCATE2 : begin
				cif.dREN = 1;
				if(!dcif.dmemaddr[2]) begin
					d_other_addr = dcif.dmemaddr + 4;
				end else begin
					d_other_addr = dcif.dmemaddr - 4;
				end

				cif.daddr = d_other_addr;

				if(dcif.dmemaddr[2]) begin
					dcif.dmemload = cacheReg[acc_map[d_index]][d_index][63:32];  
				end else begin
					dcif.dmemload = cacheReg[acc_map[d_index]][d_index][31:0];  
				end
				
				if(!cif.dwait) begin
					n_acc_map[d_index] = acc_map[d_index]+1;
					dcif.dhit = 1;

					if(d_other_addr[2]) begin
						n_cacheReg[acc_map[d_index]][d_other_addr[5:3]][63:32] = cif.dload;
					end else begin
						n_cacheReg[acc_map[d_index]][d_other_addr[5:3]][31:0] = cif.dload;
					end

					if(dcif.dmemWEN) begin
						n_cacheReg[acc_map[d_index]][d_index][90] = 1;
						
						if (dcif.dmemaddr[2]) begin
							n_cacheReg[acc_map[d_index]][d_index][63:32] = dcif.dmemstore;
						end else begin
							n_cacheReg[acc_map[d_index]][d_index][31:0]  = dcif.dmemstore;  
						end
					end 
				end
			end

			WBACK1 : begin				
				cif.dWEN = 1;
				n_cacheReg[acc_map[d_index]][d_index][90] = 0;
				cif.daddr = {cacheReg[acc_map[d_index]][d_index][89:64], dcif.dmemaddr[5:2], 2'b00};
				if(dcif.dmemaddr[2]) begin
					cif.dstore = cacheReg[acc_map[d_index]][d_index][63:32];
				end else begin
					cif.dstore = cacheReg[acc_map[d_index]][d_index][31:0];  
				end
			end

			WBACK2 : begin
				cif.dWEN = 1;
				if(!dcif.dmemaddr[2]) begin
					d_other_addr = dcif.dmemaddr + 4;
				end else begin
					d_other_addr = dcif.dmemaddr - 4;
				end

				cif.daddr = {cacheReg[acc_map[d_index]][d_other_addr[5:3]][89:64], d_other_addr[5:2], 2'b00};

				if(d_other_addr[2]) begin
					cif.dstore = cacheReg[acc_map[d_index]][d_other_addr[5:3]][63:32];
				end else begin
					cif.dstore = cacheReg[acc_map[d_index]][d_other_addr[5:3]][31:0];
				end
			end

			FLUSH1 : begin
				if (cacheReg[count[0]][count[3:1]][90]) begin
					cif.dWEN = 1;
					cif.daddr = {cacheReg[count[0]][count[3:1]][89:64], count[3:1], 3'b100};
					cif.dstore = cacheReg[count[0]][count[3:1]][63:32];
				end else if (count != 15) begin
					n_count = count + 1; 
				end
			end

			FLUSH2 : begin
				cif.dWEN = 1;
				cif.daddr = {cacheReg[count[0]][count[3:1]][89:64], count[3:1], 3'b000};
				cif.dstore = cacheReg[count[0]][count[3:1]][31:0];
				if(!cif.dwait) begin
					if (count != 15) begin
						n_count = count + 1;
					end 
				end
			end

			HIT_CNT : begin
				cif.daddr = 32'h3100; //set to write hit count to 3100
				cif.dstore = hitCount; //store the hit count
				cif.dREN = 0;
				cif.dWEN = 1;
			end
			
			END_FLUSH: begin
				cif.dREN = 0;
				cif.dWEN = 0;
				n_flushReg = 1;
				cif.daddr = word_t'('0);
			end
		endcase
	end

endmodule 

