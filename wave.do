onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/peif/EX_result_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/peif/EX_RegWen_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/peif/EX_RegDest_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/pdif/ID_Instr_OUT
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/ForwardA
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/ForwardB
add wave -noupdate /system_tb/DUT/CPU/DP/alif/alu_op
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_a
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_b
add wave -noupdate /system_tb/DUT/CPU/DP/alif/port_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {168 ps} 0}
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
WaveRestoreZoom {0 ps} {1 ns}
