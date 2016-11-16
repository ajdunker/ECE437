onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/dhit
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/dmemREN
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/dmemWEN
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/dmemaddr
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/dmemload
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/dmemstore
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/flushed
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/halt
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/ihit
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/imemREN
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/imemaddr
add wave -noupdate -group dpif0 /system_tb/DUT/CPU/DP0/dpif/imemload
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/dhit
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/dmemREN
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/dmemWEN
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/dmemaddr
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/dmemload
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/dmemstore
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/flushed
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/halt
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/ihit
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/imemREN
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/imemaddr
add wave -noupdate -group dpif1 /system_tb/DUT/CPU/DP1/dpif/imemload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CC/cpuid
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/CC/state
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/cacheValues
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/data_stored
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/i
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/index
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/instruction
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/nRST
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/n_cacheValues
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/n_instruction
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/same_tag
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/tag
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/tagToCheck
add wave -noupdate -group icache0 /system_tb/DUT/CPU/CM0/ICACHE/valid_chk
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/acc_map
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/cacheReg
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/count
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/d_data_stored
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/d_data_stored_0
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/d_data_stored_1
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/d_index
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/d_other_addr
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/d_same_tag
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/dirtyCheck0
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/dirtyCheck1
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/flushReg
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/flushWait
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/hitCount
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/i
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/missCount
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nRST
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_acc_map
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_cacheReg
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_count
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_flushReg
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_hitCount
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_missCount
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/n_state
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nextSetCount
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nextWayCount
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/setCount
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_index
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_same_tag
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_tag
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_tag_chk_0
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_tag_chk_1
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_valid_chk_0
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_valid_chk_1
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/tag
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/tagToCheck0
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/tagToCheck1
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/test
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/validCheck0
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/validCheck1
add wave -noupdate -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/wayCount
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/cacheValues
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/data_stored
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/i
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/index
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/instruction
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/nRST
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/n_cacheValues
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/n_instruction
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/same_tag
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/tag
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/tagToCheck
add wave -noupdate -group icache1 /system_tb/DUT/CPU/CM1/ICACHE/valid_chk
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/acc_map
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/cacheReg
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/count
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/d_data_stored
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/d_data_stored_0
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/d_data_stored_1
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/d_index
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/d_other_addr
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/d_same_tag
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/dirtyCheck0
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/dirtyCheck1
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/flushReg
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/flushWait
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/hitCount
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/i
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/missCount
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nRST
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_acc_map
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_cacheReg
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_count
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_flushReg
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_hitCount
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_missCount
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/n_state
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nextSetCount
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nextWayCount
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/setCount
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_index
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_same_tag
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_tag
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_tag_chk_0
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_tag_chk_1
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_valid_chk_0
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_valid_chk_1
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/tag
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/tagToCheck0
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/tagToCheck1
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/test
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/validCheck0
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/validCheck1
add wave -noupdate -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/wayCount
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {920467 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4808156 ps}
