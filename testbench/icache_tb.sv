// Alex Dunker
// adunker@purdue.edu
// icache Test Bench

`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"

import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module icache_tb;

	parameter PERIOD = 10;
	logic CLK = 0, nRST;
	// clock
	always #(PERIOD/2) CLK++;
	// interface
	caches_if cif ();
	datapath_cache_if dcif ();

	test PROG(CLK, nRST, dcif, cif);
	icache IC (CLK, nRST, dcif, cif);

endmodule // icache_tb

program test(
	input logic CLK,
	output logic nRST,
	datapath_cache_if dcif,
	caches_if cif
);

	parameter PERIOD = 10;

	initial begin

		dcif.dmemWEN = 0;
		dcif.dmemREN = 0;
		dcif.halt = 0;

		nRST = 1'b0;
		#(PERIOD*1);
		nRST = 1'b1;
		#(PERIOD*1);
		dcif.imemREN = 0;
		dcif.imemaddr = 0;
		cif.iwait = 0;
		cif.iload = 0;
		#(PERIOD*1);

		//add something to the cache
		dcif.imemREN = 1;
		dcif.imemaddr = '0;
		cif.iwait = 0;
		cif.iload = '1;
		#(PERIOD*1);

		//read entry in cache
		dcif.imemREN = 1;
		dcif.imemaddr = 0;
		cif.iwait = 0;
		cif.iload = '0;
		#(PERIOD*1);

		//fill address 1
		dcif.imemREN = 1;
		dcif.imemaddr = 1*4;
		cif.iwait = 0;
		cif.iload = 1;
		#(PERIOD*1);

		//fill address 2
		dcif.imemREN = 1;
		dcif.imemaddr = 2*4;
		cif.iwait = 0;
		cif.iload = 2;
		#(PERIOD*1);

		//fill address 3
		dcif.imemREN = 1;
		dcif.imemaddr = 3*4;
		cif.iwait = 0;
		cif.iload = 3;
		#(PERIOD*1);

		//fill address 4
		dcif.imemREN = 1;
		dcif.imemaddr = 4*4;
		cif.iwait = 0;
		cif.iload = 4;
		#(PERIOD*1);

		//fill address 5
		dcif.imemREN = 1;
		dcif.imemaddr = 5*4;
		cif.iwait = 0;
		cif.iload = 25;
		#(PERIOD*1);

		//replace 0
		dcif.imemREN = 1;
		dcif.imemaddr = 32'hffff0000;
		cif.iwait = 0;
		cif.iload = '0;
		#(PERIOD*1);

		//wait
		dcif.imemREN = 1;
		dcif.imemaddr = 3;
		cif.iwait = 1;
		cif.iload = '0;
		#(PERIOD*5);
		cif.iwait = 0;
		
		// read from cache
		#(PERIOD*1);
		dcif.imemREN = 1;
		dcif.imemaddr = 3*4;
		cif.iwait = 0;
		cif.iload = '0;

		#(PERIOD*1);

		dcif.imemREN = 1;
		dcif.imemaddr = 32'b00001010000000000000000000001100;
		cif.iwait = 0;
		cif.iload = 15;


		#(PERIOD*3);
	end

endprogram
