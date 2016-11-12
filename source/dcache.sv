// Alex Dunker
// adunker@purdue.edu
//Mitch Bouma
//mbouma@purdue.edu

// dcache

`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module dcache 
(

	input logic CLK, nRST,

  	input word_t ccsnoopaddr,
  	input logic ccwait,
  	input logic ccinv,
  	input logic dwait,
  	input word_t dload,
  	input logic ccatomicinvalidate,
  	input logic cccofreetomove,

  	output logic cctrans,
  	output logic dREN,
  	output logic dWEN,
  	output word_t daddr,
  	output word_t dstore,
  	output logic ccwrite,
  	output logic ccsnoopchecking,
  	output word_t ccsnoopvalue,
  	output logic ccsnoopvalid,
  	output logic ccatomicinvalidating,
  	output word_t ccatomicaddr,

	datapath_cache_if dcif
	//caches_if cif
);
	parameter CPUID = 0;
	typedef enum {IDLE, ALLOCATE1, ALLOCATE2, WBACK1, WBACK2, SNOOP_CHK, SNOOP_WRITE1, SNOOP_WRITE2, FLUSH1, FLUSH2, HIT_CNT, END_FLUSH} state_type;
	state_type state, n_state;

	//92 bits wide, 8 rows, 2 pieces of data per row
	logic [1:0][7:0][91:0] cacheReg;
	logic [1:0][7:0][91:0] n_cacheReg;
	logic [31:0] linkReg;
  	logic [31:0] n_linkReg;
  	logic link_valid;
  	logic n_link_valid;
	logic [25:0] tag;
	logic [2:0] d_index;
	logic [25:0] tagToCheck0, tagToCheck1;
	logic validCheck0, validCheck1;
	logic dirtyCheck0, dirtyCheck1;
	logic [31:0] d_data_stored_0, d_data_stored_1, d_data_stored;
	logic [1:0] d_same_tag;
	logic [7:0] acc_map, n_acc_map;
	logic [31:0] d_other_addr;
	logic [31:0] hitCount, n_hitCount, missCount, n_missCount;
	logic [4:0]  count, n_count;
	logic flushReg, n_flushReg;
	logic test, flushWait, wayCount, nextWayCount;
	logic [3:0] setCount, nextSetCount;
	logic canstore;

  	logic [2:0] snoop_index;
  	logic [25:0]snoop_tag;
  	logic [25:0] snoop_tag_chk_0;
  	logic [25:0] snoop_tag_chk_1;
  	logic snoop_valid_chk_0;
  	logic snoop_valid_chk_1;
  	logic [31:0] snoop_data_stored_0;
  	logic [31:0] snoop_data_stored_1;
  	logic [1:0] snoop_same_tag;

  	assign snoop_tag = ccsnoopaddr[31:6];
  	assign snoop_index = ccsnoopaddr[5:3];
  	assign snoop_tag_chk_0 = cacheReg[0][snoop_index][89:64];
 	assign snoop_tag_chk_1 = cacheReg[1][snoop_index][89:64];
  	assign snoop_valid_chk_0 = cacheReg[0][snoop_index][91];
  	assign snoop_valid_chk_1 = cacheReg[1][snoop_index][91];
  	assign snoop_data_stored_0 = ccsnoopaddr[2] ? cacheReg[0][snoop_index][63:32] : cacheReg[0][snoop_index][31:0];
  	assign snoop_data_stored_1 = ccsnoopaddr[2] ? cacheReg[1][snoop_index][63:32] : cacheReg[1][snoop_index][31:0];
  	assign snoop_same_tag = (snoop_tag == snoop_tag_chk_0) ? 2'b00 : ((snoop_tag == snoop_tag_chk_1) ? 2'b01 : 2'b10);
  	assign ccsnoopvalue = (snoop_same_tag == 2'b00) ? snoop_data_stored_0 : snoop_data_stored_1; 
  	assign ccsnoopvalid = (snoop_valid_chk_0 == 1 && snoop_same_tag == 2'b00) ? 1 : ((snoop_valid_chk_1 == 1 && snoop_same_tag == 2'b01) ? 1 : 0); 


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
			missCount <= '0;
			setCount <= '0;
			wayCount <= '0;
			linkReg <= '0;
			link_valid <= '0;
		end else begin
			cacheReg <= n_cacheReg;
			state <= n_state;
			acc_map <= n_acc_map;
			hitCount <= n_hitCount;
			count <= n_count;
			flushReg <= n_flushReg;
			missCount <= n_missCount;
			setCount <= nextSetCount;
			wayCount <= nextWayCount;
			linkReg <= n_linkReg;
      		link_valid <= n_link_valid;
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
		ccatomicaddr = linkReg;

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

		if (dcif.datomic) begin
			if (linkReg != dcif.dmemaddr || link_valid == 0) begin
				canstore = 0;
			end else begin
				canstore = 1;
			end
		end else begin
			canstore = 1;
		end
	end

	always_comb begin
		n_state = IDLE;
		casez (state)
			IDLE: begin
				if (ccwait == 1) begin
					n_state = SNOOP_CHK;
				end else if (dcif.dmemREN && ccwait == 0) begin
					if (d_same_tag != 2'b10) begin
						if (d_same_tag == 2'b00 && validCheck0 == 1) begin
							n_state = IDLE;
						end else if (d_same_tag == 2'b01 && validCheck1 == 1) begin
							n_state = IDLE;
						end else begin
							if((!validCheck0) || (!validCheck1)) begin
								n_state = ALLOCATE1;
							end else if ((!dirtyCheck0) || (!dirtyCheck1)) begin
								n_state = ALLOCATE1;
							end else begin
								n_state = WBACK1;
							end
						end
					end else begin
						if (dcif.halt) begin
							n_state = FLUSH1;
						end else if((!validCheck0) || (!validCheck1)) begin
							n_state = ALLOCATE1;
						end else if ((!dirtyCheck0) || (!dirtyCheck1)) begin
							n_state = ALLOCATE1;
						end else begin
							n_state = WBACK1;
						end 
					end
				end else if (dcif.dmemWEN && ccwait == 0) begin
					if (canstore == 0) begin
						n_state = IDLE;
					end else if (d_same_tag == 2'b00 && validCheck0 == 1) begin
						if (cccofreetomove) begin
							n_state = IDLE;
						end
					end else if (d_same_tag == 2'b01 && validCheck1==1) begin
						if (cccofreetomove) begin
							n_state = IDLE;
						end
					end else begin
						if (dcif.halt) begin
							n_state = FLUSH1;
						end else begin
							if (!validCheck0 || !validCheck1 || !dirtyCheck0 || !dirtyCheck1) begin
								n_state = ALLOCATE1;
							end else begin
								if (dcif.datomic) begin
									if (dcif.dmemaddr == linkReg && link_valid == 1) begin
										n_state = WBACK1;
									end
								end else begin
									n_state = WBACK1;
								end
							end
						end
					end
				end else begin
					if (dcif.halt) begin
						n_state = FLUSH1;
					end else begin
						n_state = IDLE;
					end
				end
			end
			ALLOCATE1: begin
				if (!dwait) begin
					n_state = ALLOCATE2;
				end else begin
					n_state = ALLOCATE1;
				end
			end 
			ALLOCATE2: begin
				if (!dwait) begin
					n_state = IDLE;
				end else begin
					n_state = ALLOCATE2; 
				end
			end
			WBACK1: begin
				if(!dwait) begin
					n_state = WBACK2;
				end else begin
					n_state = WBACK1;  
				end
			end
			WBACK2: begin
				if(!dwait) begin
					n_state = ALLOCATE1;
				end else begin
					n_state = WBACK2;
				end
			end
			SNOOP_CHK: begin
				if (snoop_same_tag != 2'b10) begin
					if (ccinv == 0 && cacheReg[snoop_same_tag][snoop_index][90] == 1) begin
						n_state = SNOOP_WRITE1;
					end else if (ccinv == 1 && cacheReg[snoop_same_tag][snoop_index][90] == 1) begin
						n_state = SNOOP_WRITE1;
					end else if (ccinv == 1 && cacheReg[snoop_same_tag][snoop_index][90] == 0) begin
						n_state = IDLE;
					end else begin 
						n_state = IDLE;
					end
				end else begin
					n_state = IDLE;
				end
			end
			SNOOP_WRITE1: begin
				if(!dwait) begin
        			n_state = SNOOP_WRITE2;
      			end else begin
        			n_state = SNOOP_WRITE1;  
      			end
			end
			SNOOP_WRITE2: begin
				if(!dwait) begin
        			n_state = IDLE;
      			end else begin
        			n_state = SNOOP_WRITE2;  
      			end
			end
			FLUSH1: begin
				if ((cacheReg[count[0]][count[3:1]][90]) & !dwait) begin
					n_state = FLUSH2;
				end else if (cacheReg[count[0]][count[3:1]][90]) begin
					n_state = FLUSH1; 
				end else if (count == 16) begin
					n_state = HIT_CNT;
				end else begin
					n_state = FLUSH1; 
				end
			end
			FLUSH2: begin
				if (!dwait & count == 16) begin
					n_state = HIT_CNT;
				end else if (!dwait) begin
					n_state = FLUSH1;
				end else begin
					n_state = FLUSH2;
				end
			end
			HIT_CNT: begin
				if(!dwait) begin
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
		dREN = 0;
		dWEN = 0;
		daddr = dcif.dmemaddr;
		dstore = 0;
		d_other_addr = dcif.dmemaddr;
		n_acc_map = acc_map;
		n_hitCount = hitCount;
		n_missCount = missCount;
		n_count = count;
		n_flushReg = 0;
		nextWayCount = wayCount;
		nextSetCount = setCount;
		cctrans = 0;
		//n_state = state;
		d_other_addr = dcif.dmemaddr;
		n_linkReg = linkReg;
		n_link_valid = link_valid;
		dcif.datomicSTATE = 2'b10;
		ccatomicinvalidating = 0;

		if(ccwait == 1) begin
    		ccwrite = 0;
  		end else begin
    		ccwrite = dcif.dmemWEN;
  		end
  
  		if (ccatomicinvalidate) begin
    		n_link_valid = 0;
  		end

  		ccsnoopchecking = 0;

		casez (state)
			IDLE : begin
				if(dcif.dmemREN && ccwait == 0) begin
					if (dcif.datomic) begin
						n_linkReg = dcif.dmemaddr;
						n_link_valid = 1;
					end
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
						end	else begin
							if ((!validCheck0) || (!validCheck1)) begin
								cctrans = 1;
								if (!validCheck0) begin
									n_acc_map[d_index] = 0;
								end else begin
									n_acc_map[d_index] = 1;
								end
							end else if ((!dirtyCheck0) || (!dirtyCheck1)) begin
								cctrans = 1;
								if (!dirtyCheck0) begin
									n_acc_map[d_index] = 0;
								end else begin
									n_acc_map[d_index] = 1;
								end
							end else begin
								cctrans = 1;
							end
						end		
					end else begin
						if ((!validCheck0) || (!validCheck1) && !dcif.halt) begin
							cctrans = 1;
							if (!validCheck0) begin
								n_acc_map[d_index] = 0;
							end else begin
								n_acc_map[d_index] = 1;
							end
						end else if ((!dirtyCheck0) || (!dirtyCheck1)) begin
							cctrans = 1;
							if (!dirtyCheck0) begin
								n_acc_map[d_index] = 0;
							end else begin
								n_acc_map[d_index] = 1;
							end
						end else begin
							cctrans = 1;
						end
					end
				end else if (dcif.dmemWEN && ccwait == 0) begin
					ccatomicinvalidating = 1;

					if (!dcif.datomic && dcif.dmemaddr == linkReg) begin
						n_link_valid = 0;
					end

					if (!canstore) begin
						dcif.dhit = 1;
						dcif.datomicSTATE = 2'b00;
					end

					if (d_same_tag == 2'b00 && validCheck0 == 1) begin
						cctrans = 1;
						dcif.dhit = 1;
						n_acc_map[d_index] = 1;

						if (dcif.datomic) begin
							n_link_valid = 0;
							dcif.datomicSTATE = 2'b01;
						end

						if (cccofreetomove) begin
							dcif.dhit = 1;
						end

						if(validCheck0 == 1) begin
							n_hitCount = hitCount + 1; //add to hit counter
						end
						if(acc_map[d_index] == d_same_tag && validCheck0) begin
							n_acc_map[d_index]=acc_map[d_index]+1;
						end
						n_cacheReg[0][d_index][90] = 1;
						n_cacheReg[0][d_index][91] = 1;
						if (dcif.dmemaddr[2] == 1) begin
							n_cacheReg[0][d_index][63:32] = dcif.dmemstore;
						end else begin
							n_cacheReg[0][d_index][31:0] = dcif.dmemstore;  
						end
					end else if (d_same_tag == 2'b01 && validCheck1 == 1) begin
						cctrans = 1;
						dcif.dhit = 1;
						n_acc_map[d_index] = 0;

						if (dcif.datomic) begin
							n_link_valid = 0;
							dcif.datomicSTATE = 2'b01;
						end

						if (cccofreetomove) begin
							dcif.dhit = 1;
						end

						if(validCheck1==1) begin
							n_hitCount = hitCount + 1; //add to hit counter
						end

						if(acc_map[d_index] == d_same_tag) begin
							n_acc_map[d_index] = acc_map[d_index] + 1;
						end

						n_cacheReg[1][d_index][90] = 1;
						n_cacheReg[1][d_index][91] = 1;

						if(dcif.dmemaddr[2] == 1) begin
							n_cacheReg[1][d_index][63:32] = dcif.dmemstore;
						end else begin
							n_cacheReg[1][d_index][31:0] = dcif.dmemstore;
						end
					end else begin
						if (!validCheck0) begin
							cctrans = 1;
							n_acc_map[d_index] = 0;
						end else if (!validCheck1) begin
							cctrans = 1;
							n_acc_map[d_index] = 1;
						end else if (!dirtyCheck0) begin
							cctrans = 1;
							n_acc_map[d_index] = 0;
						end else if (!dirtyCheck1) begin
							cctrans = 1;
							n_acc_map[d_index] = 1;
						end else begin
							if (dcif.datomic) begin
								if (dcif.dmemaddr == linkReg && link_valid == 1) begin
									cctrans = 1;
								end
							end else begin
								cctrans = 1;
							end
						end
					end
				end
			end

			ALLOCATE1 : begin
				dREN = 1;
				daddr = dcif.dmemaddr;

				n_cacheReg[acc_map[d_index]][d_index][89:64] = dcif.dmemaddr[31:6];
				n_cacheReg[acc_map[d_index]][d_index][91] = 1;

				if(!dwait) begin
					if(dcif.dmemaddr[2]) begin
						n_cacheReg[acc_map[d_index]][d_index][63:32] = dload;
					end else begin
						n_cacheReg[acc_map[d_index]][d_index][31:0] = dload;
					end
				end
			end

			ALLOCATE2 : begin
				dREN = 1;
				if(!dcif.dmemaddr[2]) begin
					d_other_addr = dcif.dmemaddr + 4;
				end else begin
					d_other_addr = dcif.dmemaddr - 4;
				end

				daddr = d_other_addr;

				if(dcif.dmemaddr[2]) begin
					dcif.dmemload = cacheReg[acc_map[d_index]][d_index][63:32];  
				end else begin
					dcif.dmemload = cacheReg[acc_map[d_index]][d_index][31:0];  
				end
				
				if(!dwait) begin
					n_acc_map[d_index] = acc_map[d_index]+1;
					dcif.dhit = 1;
					n_missCount = missCount + 1;
					if(d_other_addr[2]) begin
						n_cacheReg[acc_map[d_index]][d_other_addr[5:3]][63:32] = dload;
					end else begin
						n_cacheReg[acc_map[d_index]][d_other_addr[5:3]][31:0] = dload;
					end

					if(dcif.dmemWEN) begin
						if (dcif.datomic) begin
							n_link_valid = 0;
							dcif.datomicSTATE = 2'b01;
						end

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
				dWEN = 1;
				n_cacheReg[acc_map[d_index]][d_index][90] = 0;
				daddr = {cacheReg[acc_map[d_index]][d_index][89:64], dcif.dmemaddr[5:2], 2'b00};
				if(dcif.dmemaddr[2]) begin
					dstore = cacheReg[acc_map[d_index]][d_index][63:32];
				end else begin
					dstore = cacheReg[acc_map[d_index]][d_index][31:0];  
				end
			end

			WBACK2 : begin
				dWEN = 1;
				if(!dcif.dmemaddr[2]) begin
					d_other_addr = dcif.dmemaddr + 4;
				end else begin
					d_other_addr = dcif.dmemaddr - 4;
				end

				daddr = {cacheReg[acc_map[d_index]][d_other_addr[5:3]][89:64], d_other_addr[5:2], 2'b00};

				if(d_other_addr[2]) begin
					dstore = cacheReg[acc_map[d_index]][d_other_addr[5:3]][63:32];
				end else begin
					dstore = cacheReg[acc_map[d_index]][d_other_addr[5:3]][31:0];
				end
			end

			SNOOP_CHK : begin
				ccsnoopchecking = 1;
      			if (snoop_same_tag != 2'b10) begin
        			if (ccinv == 0 && cacheReg[snoop_same_tag][snoop_index][90] == 1) begin
          				ccwrite = 1;
          				n_cacheReg[snoop_same_tag][snoop_index][90] = 0;
        			end else if (ccinv == 1 && cacheReg[snoop_same_tag][snoop_index][90] == 1) begin
          				if (linkReg == ccsnoopaddr) begin
            				n_link_valid = 0;  
          				end
		          		ccwrite = 1;
		          		n_cacheReg[snoop_same_tag][snoop_index][91] = 0;
		          		n_cacheReg[snoop_same_tag][snoop_index][90] = 0;
        			end else if (ccinv == 1 && cacheReg[snoop_same_tag][snoop_index][90] == 0) begin
          				if (linkReg == ccsnoopaddr) begin
            				n_link_valid = 0;
          				end
          				n_cacheReg[snoop_same_tag][snoop_index][91] = 0;
          				n_cacheReg[snoop_same_tag][snoop_index][90] = 0;
        			end
      			end
			end

			SNOOP_WRITE1 : begin				
				dWEN = 1;
				n_cacheReg[acc_map[d_index]][d_index][90] = 0;
				daddr = {cacheReg[snoop_same_tag][snoop_index][89:64], ccsnoopaddr[5:2], 2'b00};
				if(ccsnoopaddr[2]) begin
					dstore = cacheReg[snoop_same_tag][snoop_index][63:32];
				end else begin
					dstore = cacheReg[snoop_same_tag][snoop_index][31:0];  
				end
			end

			SNOOP_WRITE2 : begin
				dWEN = 1;
				if(!ccsnoopaddr[2]) begin
					d_other_addr = ccsnoopaddr + 4;
				end else begin
					d_other_addr = ccsnoopaddr - 4;
				end

				daddr = {cacheReg[snoop_same_tag][d_other_addr[5:3]][89:64], d_other_addr[5:2], 2'b00};

				if(d_other_addr[2]) begin
					dstore = cacheReg[snoop_same_tag][d_other_addr[5:3]][63:32];
				end else begin
					dstore = cacheReg[snoop_same_tag][d_other_addr[5:3]][31:0];
				end
			end

			FLUSH1 : begin
				if (cacheReg[count[0]][count[3:1]][90]) begin
					dWEN = 1;
					daddr = {cacheReg[count[0]][count[3:1]][89:64], count[3:1], 3'b100};
					dstore = cacheReg[count[0]][count[3:1]][63:32];
					if (!dwait) begin
						n_cacheReg[count[0]][count[3:1]][91] = 0;
          				n_cacheReg[count[0]][count[3:1]][90] = 0;
          			end
				end else if (count != 16) begin
					n_count = count + 1; 
				end
			end

			FLUSH2 : begin
				dWEN = 1;
				daddr = {cacheReg[count[0]][count[3:1]][89:64], count[3:1], 3'b000};
				dstore = cacheReg[count[0]][count[3:1]][31:0];
				n_cacheReg[count[0]][count[3:1]][91] = 0;
      			n_cacheReg[count[0]][count[3:1]][90] = 0;
				if(!dwait) begin
					if (count != 16) begin
						//n_cacheReg[count[0]][count[3:1]][91:90] = 2'b00;
						n_count = count + 1;
					end 
				end
			end

			HIT_CNT : begin
				daddr = 32'h3100; //set to write hit count to 3100
				dstore = hitCount - missCount; //store the hit count
				dREN = 0;
				dWEN = 1;
			end
			
			END_FLUSH: begin
				dREN = 0;
				dWEN = 0;
				n_flushReg = 1;
				daddr = word_t'('0);
			end
		endcase
	end

endmodule 
