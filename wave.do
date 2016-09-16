onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate -group {Data PATH} /system_tb/nRST
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/CLK
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/nRST
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/pc
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/next_pc
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/signedExtImm
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/zeroExtImm
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/luiImm
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/shamt
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/pc4
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/pc_jump
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/next_pc_reg
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/next_pc_br
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/pcEN
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/halt_reg
add wave -noupdate -group {Data PATH} /system_tb/DUT/CPU/DP/n_halt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1342242019 ps} 0}
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
WaveRestoreZoom {1341730 ns} {1343318942 ps}
