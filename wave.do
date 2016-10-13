onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Instr
add wave -noupdate /system_tb/DUT/CPU/DP/peif/EX_RegWen_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/peif/EX_RegDest_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/FU/rt
add wave -noupdate /system_tb/DUT/CPU/DP/FU/rs
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/ForwardA
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/ForwardB
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ALUsrc
add wave -noupdate /system_tb/DUT/CPU/DP/pdif/ID_ALUsrc_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/pdif/ID_ALUSrc2_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/huif/stall
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_b
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_o
add wave -noupdate -expand /system_tb/DUT/CPU/DP/RF/register
add wave -noupdate /system_tb/DUT/CPU/DP/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {937990 ps} 0}
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
WaveRestoreZoom {666820 ps} {1237223 ps}
