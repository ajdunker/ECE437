// Alex Dunker
// adunker@purdue.edu
// icache Test Bench

`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"

import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module dcache_tb;

	parameter PERIOD = 10;
	logic CLK = 0, nRST;
	// clock
	always #(PERIOD/2) CLK++;
	// interface
	caches_if cif ();
	datapath_cache_if dcif ();

	test PROG(CLK, nRST, dcif, cif);
	dcache DC (CLK, nRST, dcif, cif);

endmodule

program test(
	input logic CLK,
	output logic nRST,
	datapath_cache_if dcif,
	caches_if cif
);

	initial begin
		parameter PERIOD = 10;
		parameter CPUID = 0;

		cif.dwait = 1'b0;
		cif.dload = 1'b0;

		nRST = 1'b0;
		#(PERIOD*1);
		@(posedge CLK);
		nRST = 1'b1;
		#(PERIOD*1);

<<<<<<< HEAD
		//load in deadbeef
		dcif.dmemaddr = 32'h00000000;
		dcif.dmemstore = 32'hdeadbeef;
=======
		//load in something
		dcif.dmemaddr = 32'h00000000;
		dcif.dmemstore = 32'hballoons;
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
		dcif.dmemREN = 1'b1;
		dcif.dmemWEN = 1'b0;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'hffffffff;

		#(PERIOD*1);
<<<<<<< HEAD
		//load it in the other way
		dcif.dmemaddr = 32'hffff0000;
		dcif.dmemstore = 32'hdeadbeef;
=======
		//load it into the other side
		dcif.dmemaddr = 32'hffff0000;
		dcif.dmemstore = 32'hballoons;
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
		dcif.dmemREN = 1'b1;
		dcif.dmemWEN = 1'b0;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'h0000ffff;

		#(PERIOD*2);
		#(PERIOD*2);
		//read next index from RAM
		dcif.dmemaddr = 32'b00000000000000000000000000001000;
		dcif.dmemstore = 32'hbad1bad1;
		dcif.dmemREN = 1'b1;
		dcif.dmemWEN = 1'b0;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'h00000000;

		dcif.dmemREN = 1'b0;
		#(PERIOD*1);
		//write to data already in cache
		dcif.dmemaddr = 32'b00000000000000000000000000001000;
		dcif.dmemstore = 32'hffff0000;
		dcif.dmemREN = 1'b0;
		dcif.dmemWEN = 1'b1;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'hbad1bad1;
		dcif.dmemWEN = 1'b0;

		#(PERIOD*2);
		//consecutive read hits
		dcif.dmemaddr = 32'b00000000000000000000000000001000;
		dcif.dmemstore = 32'hffff0000;
		dcif.dmemREN = 1'b1;
		dcif.dmemWEN = 1'b0;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'hbad1bad1;

		#(PERIOD*2);
		dcif.dmemREN = 1'b0;
		//write to data not in cache
		dcif.dmemaddr = 32'b00000000000000000000000000010000;
		dcif.dmemstore = 32'hf0faf0f0;
		dcif.dmemREN = 1'b0;
		dcif.dmemWEN = 1'b1;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'hbad1bad1;
		#(PERIOD*2);


		#(PERIOD*1);
<<<<<<< HEAD
		//datapath read hit way0
=======
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
		dcif.dmemaddr = 32'b00000000000000000000000000000000;
		dcif.dmemstore = 32'hbad1bad1;
		dcif.dmemREN = 1'b1;
		dcif.dmemWEN = 1'b0;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload[CPUID] = 32'hbad1bad1;

		#(PERIOD*1);
<<<<<<< HEAD
		//datapath read hit way1
=======
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
		dcif.dmemaddr = 32'hffff0000;
		dcif.dmemstore = 32'hbad1bad1;
		dcif.dmemREN = 1'b1;
		dcif.dmemWEN = 1'b0;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'hbad1bad1;
		#(PERIOD*1);
		dcif.dmemREN = 1'b0;

		#(PERIOD*1);
		//eviction on read clean
<<<<<<< HEAD
		dcif.dmemaddr = 32'b10101010101000000000000000000000; // should replace way0, index0
=======
		dcif.dmemaddr = 32'b10101010101000000000000000000000;
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
		dcif.dmemstore = 32'hbad1bad1;
		dcif.dmemREN = 1'b1;
		dcif.dmemWEN = 1'b0;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'h10101010;

		#(PERIOD*1);
		//eviction on write clean
<<<<<<< HEAD
		dcif.dmemaddr = 32'b01010101010100000000000000000000; // should replace way1, index0
=======
		dcif.dmemaddr = 32'b01010101010100000000000000000000;
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995
		dcif.dmemstore = 32'hFEEDBEEF;
		dcif.dmemREN = 1'b0;
		dcif.dmemWEN = 1'b1;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'hbad1bad1;
		#(PERIOD*2); // 

		#(PERIOD*2);
		dcif.dmemREN = 1'b0;
		//write to data not in cache
		dcif.dmemaddr = 32'b00001111000000000000000000010000;
		dcif.dmemstore = 32'hf0fffff0;
		dcif.dmemREN = 1'b0;
		dcif.dmemWEN = 1'b1;
		dcif.halt = 1'b0;
		cif.dwait = 1'b0;
		cif.dload = 32'hbad1bad1;
		#(PERIOD*2);


		#(PERIOD*5);
	end
<<<<<<< HEAD
endprogram
=======
endprogram
>>>>>>> 1919a2ea5b5e641c1059d7433b74df1f98905995