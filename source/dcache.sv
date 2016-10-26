// Alex Dunker
// adunker@purdue.edu

// dcache

`include "datapath_cache_if.vh"
`include "cache_control_if.vh"

`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module dcache (
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if cif
);

<<<<<<< HEAD
<<<<<<< HEAD
	/**** D_Cache****/
	//8 slots each sid, total 1024 bits
	//valid[91], dirty[90], tag[89:64], data1[63:32], data2[31:0]
	logic [1:0][7:0][91:0] cacheReg;
	logic [1:0][7:0][91:0] n_cacheReg;

	typedef enum {IDLE, ALL1, ALL2, WB1, WB2, FLUSH1, FLUSH2, HIT_CNT} state_type;
	state_type state, n_state;

	//values for checking dcache
	logic [25:0] tag;
	logic [2:0] d_index;

	logic [25:0] tag_chk_0, tag_chk_1;
	logic valid_chk_0, valid_chk_1;
	logic dirty_chk_0, dirty_chk_1;

	logic [31:0] d_data_stored_0, d_data_stored_1, d_data_stored;
	logic [1:0] d_same_tag; //00:no match, 01:match 0, 10:match 1

	logic [7:0] acc_map, n_acc_map;

	logic [31:0] d_other_addr;

	//just for flush
	logic [31:0] hitT, n_hitT;
	logic [3:0]  count, n_count;

	logic flushReg, n_flushReg;
 
	assign tag = dcif.dmemaddr[31:6];
	assign d_index = dcif.dmemaddr[5:3];

	assign tag_chk_0 = cacheReg[0][d_index][89:64];
	assign tag_chk_1 = cacheReg[1][d_index][89:64];
	assign valid_chk_0 = cacheReg[0][d_index][91];
	assign valid_chk_1 = cacheReg[1][d_index][91];
	assign dirty_chk_0 = cacheReg[0][d_index][90];
	assign dirty_chk_1 = cacheReg[1][d_index][90];


	assign d_data_stored_0 = dcif.dmemaddr[2] ? cacheReg[0][d_index][63:32] : cacheReg[0][d_index][31:0];
	assign d_data_stored_1 = dcif.dmemaddr[2] ? cacheReg[1][d_index][63:32] : cacheReg[1][d_index][31:0];
	assign d_same_tag = (tag == tag_chk_0) ? 2'b00 : ((tag == tag_chk_1) ? 2'b01 : 2'b10);
	assign d_data_stored = (d_same_tag == 2'b00) ? d_data_stored_0 : d_data_stored_1;

	assign dcif.flushed = flushReg;

	integer i;
	
	always_ff @(posedge CLK, negedge nRST) begin
    	if (!nRST) begin
			for (i=0;i<8;i++) begin
				cacheReg[1][i][91:90]<=0;
				cacheReg[0][i][91:90]<=0;
			end
			state <= IDLE;
			acc_map <= '0;
			hitT <= '0;
			count <= '0;
			flushReg <= '0;
    	end else begin
			//dcache
			cacheReg <= n_cacheReg;
			state <= n_state;
			acc_map <= n_acc_map;
			hitT <= n_hitT;
			count <= n_count;
			flushReg <= n_flushReg;
    	end
	end


	//dcache comb logic
	always_comb begin
		//set default values
=======
=======
>>>>>>> master
	//92 bits wide, 8 rows, 2 pieces of data per row

	logic [1:0][7:0][91:0] cacheReg;
	logic [1:0][7:0][91:0] n_cacheReg;

	typedef enum {IDLE, ALLOCATE1, ALLOCATE2, WBACK1, WBACK2, FLUSH1, FLUSH2, HIT_CNT, END_FLUSH} state_type;
	state_type state, n_state;

	logic [25:0] tag;
	logic [2:0] d_index;
	logic [25:0] tagToCheck0, tagToCheck1;
	logic validCheck0, validCheck1;
	logic dirtyCheck0, dirtyCheck1;
	logic [31:0] d_data_stored_0, d_data_stored_1, d_data_stored;
	logic [1:0] d_same_tag;
	logic [7:0] acc_map, n_acc_map;
	logic [31:0] d_other_addr;

	logic [31:0] hitT, n_hitT;
	logic [3:0]  count, n_count;
	logic flushReg, n_flushReg;
 
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

	integer i;
	always_ff @(posedge CLK, negedge nRST) begin
	    	if (!nRST) begin
				for (i=0;i<8;i++) begin
					cacheReg[1][i][91:90]<=0;
					cacheReg[0][i][91:90]<=0;
				end
				state <= IDLE;
				acc_map <= '0;
				hitT <= '0;
				count <= '0;
				flushReg <= '0;
	    	end else begin
				cacheReg <= n_cacheReg;
				state <= n_state;
				acc_map <= n_acc_map;
				hitT <= n_hitT;
				count <= n_count;
				flushReg <= n_flushReg;
    		end
	end

	always_comb begin
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
		n_state = IDLE;
		n_cacheReg = cacheReg;
		dcif.dmemload = 0;
		dcif.dhit = 0;
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
		cif.dREN = 0;
		cif.dWEN = 0;
		cif.daddr = dcif.dmemaddr;
		cif.dstore = 0;
		d_other_addr = dcif.dmemaddr;
<<<<<<< HEAD
<<<<<<< HEAD

		n_acc_map = acc_map; //store index least used

=======
		n_acc_map = acc_map;
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
		n_acc_map = acc_map;
>>>>>>> master
		n_hitT = hitT;
		n_count = count;
		n_flushReg = 0;

		casez (state)
			IDLE : begin
<<<<<<< HEAD
<<<<<<< HEAD
				if(dcif.dmemREN) begin //read mode 
					if(d_same_tag != 2'b10) begin //there is a potential match
						if (d_same_tag == 2'b00 && valid_chk_0 == 1) begin //data match on block 0 
							dcif.dhit = 1;
							n_hitT=hitT+1;
							dcif.dmemload = d_data_stored;
							n_acc_map[d_index] = 1;                                             
							n_state = IDLE;
						end else if (valid_chk_1 == 1 && d_same_tag == 2'b01) begin//data match on block 1 
=======
=======
>>>>>>> master
				if(dcif.dmemREN) begin
					if(d_same_tag != 2'b10) begin
						if (d_same_tag == 2'b00 && validCheck0 == 1) begin 
							dcif.dhit = 1;
							n_hitT = hitT + 1;
							dcif.dmemload = d_data_stored;
							n_acc_map[d_index] = 1;                                             
							n_state = IDLE;
						end else if (validCheck1 == 1 && d_same_tag == 2'b01) begin 
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
							dcif.dhit = 1;
							n_hitT=hitT+1;
							dcif.dmemload = d_data_stored;
							n_acc_map[d_index] = 0;
							n_state = IDLE;
<<<<<<< HEAD
<<<<<<< HEAD
						end else begin //no match, requesting data from mem
							if((!valid_chk_0) || (!valid_chk_1)) begin
								n_state = ALL1;
								if (!valid_chk_0) begin
									n_acc_map[d_index] = 0; //block 0 is ok to fill in new data
								end else begin
									n_acc_map[d_index] = 1; //block 1 is ok to fill in new data
								end
							end else if((!dirty_chk_0) || (!dirty_chk_1)) begin //no dirty data, override directly
								//have to write dirty back first
								n_state = ALL1;
								if(!dirty_chk_0) begin
									n_acc_map[d_index] = 0; //block 0 is available for override  
								end else begin
									n_acc_map[d_index] = 1; //block 1 is available for override
								end
							end else begin //no open spot, need wb first
								n_state = WB1;
							end
						end
					end else begin //absolutely no match, requesting data from mem
						if(dcif.halt) begin
							n_state = FLUSH1;
						end else if((!valid_chk_0) || (!valid_chk_1)) begin
							n_state = ALL1;
							if (!valid_chk_0) begin
								n_acc_map[d_index] = 0; //block 0 is ok to fill in new data
							end else begin
								n_acc_map[d_index] = 1; //block 1 is ok to fill in new data
							end
						end else if((!dirty_chk_0) || (!dirty_chk_1)) begin //no dirty data, override directly
							//have to write dirty back first
							n_state = ALL1;
							if(!dirty_chk_0) begin
								n_acc_map[d_index] = 0; //block 0 is available for override
							end else begin
								n_acc_map[d_index] = 1; //block 1 is available for override
							end
						end else begin //no open spot, need wb first
							n_state = WB1;
						end
					end
				end else if (dcif.dmemWEN) begin //write mode 
					if (d_same_tag == 2'b00) begin
						dcif.dhit = 1;
						if(valid_chk_0==1) begin
=======
=======
>>>>>>> master
						end else begin
							if ((!validCheck0) || (!validCheck1)) begin
								n_state = ALLOCATE1;
								if (!validCheck0) begin
									n_acc_map[d_index] = 0;
								end else begin
									n_acc_map[d_index] = 1;
								end
							end else if((!dirtyCheck0) || (!dirtyCheck1)) begin
								n_state = ALLOCATE1;
								if(!dirtyCheck0) begin
									n_acc_map[d_index] = 0; 
								end else begin
									n_acc_map[d_index] = 1;
								end
							end else begin
								n_state = WBACK1;
							end
						end
					end else begin
						if(dcif.halt) begin
							n_state = FLUSH1;
						end else if((!validCheck0) || (!validCheck1)) begin
							n_state = ALLOCATE1;
							if (!validCheck0) begin
								n_acc_map[d_index] = 0;
							end else begin
								n_acc_map[d_index] = 1;
							end
						end else if((!dirtyCheck0) || (!dirtyCheck1)) begin
							n_state = ALLOCATE1;
							if(!dirtyCheck0) begin
								n_acc_map[d_index] = 0;
							end else begin
								n_acc_map[d_index] = 1;
							end
						end else begin
							n_state = WBACK1;
						end
					end
				end else if (dcif.dmemWEN) begin
					if (d_same_tag == 2'b00) begin
						dcif.dhit = 1;
						if(validCheck0==1) begin
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
							n_hitT=hitT+1;
						end
						if(acc_map[d_index] == d_same_tag) begin
							n_acc_map[d_index]=acc_map[d_index]+1;
						end
<<<<<<< HEAD
<<<<<<< HEAD
						n_cacheReg[0][d_index][90] = 1; //set dirty
						n_cacheReg[0][d_index][91] = 1; //set valid
						if (dcif.dmemaddr[2] == 1) begin //check offset 
=======
						n_cacheReg[0][d_index][90] = 1;
						n_cacheReg[0][d_index][91] = 1;
						if (dcif.dmemaddr[2] == 1) begin
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
						n_cacheReg[0][d_index][90] = 1;
						n_cacheReg[0][d_index][91] = 1;
						if (dcif.dmemaddr[2] == 1) begin
>>>>>>> master
							n_cacheReg[0][d_index][63:32] = dcif.dmemstore;
						end else begin
							n_cacheReg[0][d_index][31:0] = dcif.dmemstore;  
						end
					end else if (d_same_tag == 2'b01) begin
						dcif.dhit = 1;

<<<<<<< HEAD
<<<<<<< HEAD
						if(valid_chk_1==1) begin
=======
						if(validCheck1==1) begin
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
						if(validCheck1==1) begin
>>>>>>> master
							n_hitT=hitT+1;
						end

						if(acc_map[d_index] == d_same_tag) begin
							n_acc_map[d_index]=acc_map[d_index]+1;
						end

<<<<<<< HEAD
<<<<<<< HEAD
						n_cacheReg[1][d_index][90] = 1; //set dirty
						n_cacheReg[1][d_index][91] = 1; //set valid

						if(dcif.dmemaddr[2] == 1) begin //check offset
=======
=======
>>>>>>> master
						n_cacheReg[1][d_index][90] = 1;
						n_cacheReg[1][d_index][91] = 1;

						if(dcif.dmemaddr[2] == 1) begin
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
							n_cacheReg[1][d_index][63:32] = dcif.dmemstore;
						end else begin
							n_cacheReg[1][d_index][31:0] = dcif.dmemstore;
						end
<<<<<<< HEAD
<<<<<<< HEAD
					end else begin //no match, may require wb
						if(dcif.halt) begin
							n_state = FLUSH1;
						end else begin
							if(!valid_chk_0) begin
								n_acc_map[d_index] = 0;
								n_state = ALL1;
							end else if(!valid_chk_1) begin
								n_acc_map[d_index] = 1;
								n_state = ALL1;
							end else if(!dirty_chk_0) begin //block 0 not dirty, realloc it
								n_acc_map[d_index] = 0;
								n_state = ALL1;
							end else if (!dirty_chk_1) begin //block 1 not dirty, realloc it
								n_acc_map[d_index] = 1;
								n_state = ALL1;
							end else begin
								n_state = WB1;  
							end
						end
					end
				end else begin   //neither read nor write
=======
=======
>>>>>>> master
					end else begin
						if(dcif.halt) begin
							n_state = FLUSH1;
						end else begin
							if(!validCheck0) begin
								n_acc_map[d_index] = 0;
								n_state = ALLOCATE1;
							end else if(!validCheck1) begin
								n_acc_map[d_index] = 1;
								n_state = ALLOCATE1;
							end else if(!dirtyCheck0) begin
								n_acc_map[d_index] = 0;
								n_state = ALLOCATE1;
							end else if (!dirtyCheck1) begin
								n_acc_map[d_index] = 1;
								n_state = ALLOCATE1;
							end else begin
								n_state = WBACK1;  
							end
						end
					end
				end else begin
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
					if(dcif.halt) begin
						n_state = FLUSH1;
					end else begin
						n_state = IDLE;  
					end
				end
			end

<<<<<<< HEAD
<<<<<<< HEAD
			ALL1 : begin //alloc memory
				cif.dREN = 1;
				cif.daddr = dcif.dmemaddr;

				n_cacheReg[acc_map[d_index]][d_index][89:64] = dcif.dmemaddr[31:6]; //set tag
				n_cacheReg[acc_map[d_index]][d_index][91] = 1; //set valid

				if(!cif.dwait) begin //done loading
=======
=======
>>>>>>> master
			ALLOCATE1 : begin

				cif.dREN = 1;
				cif.daddr = dcif.dmemaddr;

				n_cacheReg[acc_map[d_index]][d_index][89:64] = dcif.dmemaddr[31:6];
				n_cacheReg[acc_map[d_index]][d_index][91] = 1;

				if(!cif.dwait) begin
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
					if(dcif.dmemaddr[2]) begin
						n_cacheReg[acc_map[d_index]][d_index][63:32] = cif.dload;
					end else begin
						n_cacheReg[acc_map[d_index]][d_index][31:0] = cif.dload;
					end
					
<<<<<<< HEAD
<<<<<<< HEAD
					n_state = ALL2;
				end else begin  //not done yet
					n_state = ALL1;  
				end
			end

			ALL2 : begin
				cif.dREN = 1;
				if(!dcif.dmemaddr[2]) begin //low 32 bits
=======
=======
>>>>>>> master
					n_state = ALLOCATE2;
				end else begin
					n_state = ALLOCATE1;  
				end
			end

			ALLOCATE2 : begin

				cif.dREN = 1;
				if(!dcif.dmemaddr[2]) begin
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
					d_other_addr = dcif.dmemaddr + 4;
				end else begin
					d_other_addr = dcif.dmemaddr - 4;
				end

				cif.daddr = d_other_addr;

<<<<<<< HEAD
<<<<<<< HEAD
				//get data just loaded
=======
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
				if(dcif.dmemaddr[2]) begin
					dcif.dmemload = cacheReg[acc_map[d_index]][d_index][63:32];  
				end else begin
					dcif.dmemload = cacheReg[acc_map[d_index]][d_index][31:0];  
				end
				
				if(!cif.dwait) begin
					n_acc_map[d_index] = acc_map[d_index]+1;
					dcif.dhit = 1;
					n_state = IDLE;

					if(d_other_addr[2]) begin
						n_cacheReg[acc_map[d_index]][d_other_addr[5:3]][63:32] = cif.dload;
					end else begin
						n_cacheReg[acc_map[d_index]][d_other_addr[5:3]][31:0] = cif.dload;
					end

					if(dcif.dmemWEN) begin
<<<<<<< HEAD
<<<<<<< HEAD
						n_cacheReg[acc_map[d_index]][d_index][90] = 1; //set dirty
						//n_cacheReg[acc_map[d_index]][d_index][91] = 1; //set valid
=======
						n_cacheReg[acc_map[d_index]][d_index][90] = 1;
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
						n_cacheReg[acc_map[d_index]][d_index][90] = 1;
>>>>>>> master
						
						if (dcif.dmemaddr[2]) begin
							n_cacheReg[acc_map[d_index]][d_index][63:32] = dcif.dmemstore;
						end else begin
							n_cacheReg[acc_map[d_index]][d_index][31:0]  = dcif.dmemstore;  
						end
					end
				end else begin
<<<<<<< HEAD
<<<<<<< HEAD
					n_state = ALL2;  
				end
			end

			WB1 : begin
				cif.dWEN = 1;
				n_cacheReg[acc_map[d_index]][d_index][90] = 0; //not dirty after wb
=======
=======
>>>>>>> master
					n_state = ALLOCATE2;  
				end
			end

			WBACK1 : begin

				cif.dWEN = 1;
				n_cacheReg[acc_map[d_index]][d_index][90] = 0;
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
				cif.daddr = {cacheReg[acc_map[d_index]][d_index][89:64], dcif.dmemaddr[5:2], 2'b00};
				if(dcif.dmemaddr[2]) begin
					cif.dstore = cacheReg[acc_map[d_index]][d_index][63:32];
				end else begin
					cif.dstore = cacheReg[acc_map[d_index]][d_index][31:0];  
				end

				if(!cif.dwait) begin
<<<<<<< HEAD
<<<<<<< HEAD
					n_state = WB2;
				end else begin
					n_state = WB1;  
				end
			end

			WB2 : begin
=======
=======
>>>>>>> master
					n_state = WBACK2;
				end else begin
					n_state = WBACK1;  
				end
			end

			WBACK2 : begin
<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
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

				if(!cif.dwait) begin
<<<<<<< HEAD
<<<<<<< HEAD
					n_state = ALL1;
				end else begin
					n_state = WB2;
=======
					n_state = ALLOCATE1;
				end else begin
					n_state = WBACK2;
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
					n_state = ALLOCATE1;
				end else begin
					n_state = WBACK2;
>>>>>>> master
				end
			end

			FLUSH1 : begin
				if (cacheReg[count[0]][count[3:1]][90]) begin
					cif.dWEN = 1;
					cif.daddr = {cacheReg[count[0]][count[3:1]][89:64], count[3:1], 3'b100};
<<<<<<< HEAD
<<<<<<< HEAD
					cif.dstore = cacheReg[count[0]][count[3:1]][63:32]; //hight 32 bits
=======
					cif.dstore = cacheReg[count[0]][count[3:1]][63:32];
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
					cif.dstore = cacheReg[count[0]][count[3:1]][63:32];
>>>>>>> master
					if(!cif.dwait) begin
						n_state = FLUSH2;
					end else begin
						n_state = FLUSH1;  
					end
				end else if (count == 15) begin
					n_state = HIT_CNT;
				end else begin
					n_count = count + 1;
					n_state = FLUSH1;  
				end
			end

			FLUSH2 : begin
				cif.dWEN = 1;
				cif.daddr = {cacheReg[count[0]][count[3:1]][89:64], count[3:1], 3'b000};
<<<<<<< HEAD
<<<<<<< HEAD
				cif.dstore = cacheReg[count[0]][count[3:1]][31:0]; //low 32 bits
=======
				cif.dstore = cacheReg[count[0]][count[3:1]][31:0];
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
				cif.dstore = cacheReg[count[0]][count[3:1]][31:0];
>>>>>>> master
				if(!cif.dwait) begin
					if (count == 15) begin
						n_state = HIT_CNT;
					end else begin
						n_count = count + 1;
						n_state = FLUSH1;  
					end
				end else begin
					n_state = FLUSH2;  
				end
			end

			HIT_CNT : begin
				if(!cif.dwait) begin
					n_state = END_FLUSH;
				end else begin
					n_state = HIT_CNT;
				end
				cif.daddr = 32'h3100; //set to write hit count to 3100
				cif.dstore = hitT+16; //store the hit count
				//n_flushReg = 1;
				cif.dREN = 0;
				cif.dWEN = 1;
			end
			
			END_FLUSH: begin
				cif.dREN = 0;
				cif.dWEN = 0;
				n_flushReg = 1;
				cif.daddr = word_t'('0);
				n_state = END_FLUSH;
			end
		endcase
	end
<<<<<<< HEAD
<<<<<<< HEAD
endmodule // dcache
=======
=======
>>>>>>> master

endmodule 


<<<<<<< HEAD
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
=======
>>>>>>> master
