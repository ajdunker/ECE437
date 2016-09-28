onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Instr
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/ForwardA
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/ForwardB
add wave -noupdate /system_tb/DUT/CPU/DP/huif/stall
add wave -noupdate /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_b
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_o
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/DP/RF/register
add wave -noupdate /system_tb/DUT/CPU/DP/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3009604 ps} 0}
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
WaveRestoreZoom {2944300 ps} {3223300 ps}
