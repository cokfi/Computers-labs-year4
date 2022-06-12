onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/clock
add wave -noupdate /tb_top/ALUFNredLeds9to5
add wave -noupdate /tb_top/ALUoutGreenLeds
add wave -noupdate /tb_top/CflagRedLed1
add wave -noupdate /tb_top/NflagRedLed0
add wave -noupdate /tb_top/XvectorHex0
add wave -noupdate /tb_top/XvectorHex1
add wave -noupdate /tb_top/YvectorHex2
add wave -noupdate /tb_top/YvectorHex3
add wave -noupdate /tb_top/ZflagRedLed2
add wave -noupdate /tb_top/enableALUFNkey1
add wave -noupdate /tb_top/enableXkey2
add wave -noupdate /tb_top/enableYkey0
add wave -noupdate /tb_top/k
add wave -noupdate /tb_top/m
add wave -noupdate /tb_top/n
add wave -noupdate /tb_top/rst
add wave -noupdate /tb_top/switches
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 332
configure wave -valuecolwidth 120
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3281250 ps}
