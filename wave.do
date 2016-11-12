onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/CC/CPUS
add wave -noupdate /system_tb/DUT/CPU/CC/state
add wave -noupdate /system_tb/DUT/CPU/CC/n_state
add wave -noupdate /system_tb/DUT/CPU/CC/cpuid
add wave -noupdate /system_tb/DUT/CPU/CC/n_cpuid
add wave -noupdate -expand /system_tb/DUT/CPU/CC/ccif/iwait
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dwait
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/iREN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dREN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dWEN
add wave -noupdate -expand /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dload
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dstore
add wave -noupdate -expand /system_tb/DUT/CPU/CC/ccif/iaddr
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/daddr
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ccwait
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ccinv
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ccwrite
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/cctrans
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ccsnoopaddr
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramREN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramstate
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramstore
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramload
add wave -noupdate -expand /system_tb/DUT/CPU/CM0/ICACHE/cacheValues
add wave -noupdate /system_tb/DUT/CPU/CM1/ICACHE/cacheValues
add wave -noupdate /system_tb/DUT/CPU/cif0/iload
add wave -noupdate /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate /system_tb/DUT/CPU/cif0/iaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {64380 ps} 0}
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
WaveRestoreZoom {0 ps} {478 ns}
