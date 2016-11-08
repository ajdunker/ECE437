// Alex Dunker
// adunker@purdue.edu
// Mitch Bouma
// mbouma@purdue.edu

// Coherence Controller


`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"

module coherence_control
(
	input logic CLK, nRST,
	cache_control_if ccif
);

	import cpu_types_pkg::*;

	typedef enum {IDLE, SNOOP0, SNOOP1, WB_C0_0, WB_C0_1, WB_C1_0, WB_C1_1} state_type;

	state_type state, n_state;


	always_ff @ (posedge CLK, negedge nRST) begin
		if(!nRST) begin
			state <= IDLE;
		end else begin
			state <= n_state;
		end
	end

	always_comb begin
		casez(state)
			IDLE: begin
				if (ccif.cctrans[0]) begin
					n_state <= SNOOP1;
					ccif.ccsnoopaddr[1] = ccif.daddr[0];
					ccif.ccwait[1] = 1;
				end else if (ccif.cctrans[1]) begin
					n_state <= SNOOP0;
					ccif.ccsnoopaddr[0] = ccif.daddr[1];
					ccif.ccwait[0] = 1;
				end else begin
					n_state <= IDLE;
				end
			end

			SNOOP0 : begin
				if (ccif.ccwrite[0]) begin
					n_state = WB_C0_0;
					ccif.ccinv[1] = 1;
				end else begin
					n_state <= IDLE;
				end
			end

			SNOOP1 : begin
				if (ccif.ccwrite[1]) begin
					n_state = WB_C1_0;
					ccif.ccinv[0] = 1;
				end else begin
					n_state <= IDLE;
				end
			end

			WB_C0_0 : begin
				ccif.ccwait[0] = 1;

				if(ccif.dwait[0]) begin
					n_state = WB_C0_0;
				end else begin
					n_state = WB_C0_1;
				end
			end

			WB_C0_1 : begin
				ccif.ccwait[0] = 1;

				if(ccif.dwait[0]) begin
					n_state = WB_C0_1;
				end else begin
					n_state = IDLE;
				end
			end

			WB_C1_0 : begin
				ccif.ccwait[0] = 1;

				if(ccif.dwait[0]) begin
					n_state = WB_C1_0;
				end else begin
					n_state = WB_C1_1;
				end
			end

			WB_C1_1 : begin
				ccif.ccwait[0] = 1;

				if(ccif.dwait[0]) begin
					n_state = WB_C1_1;
				end else begin
					n_state = IDLE;
				end
			end
		endcase
	end

endmodule // coherence_control