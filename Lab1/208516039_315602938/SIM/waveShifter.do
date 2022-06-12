onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_shifter/y
add wave -noupdate -radix hexadecimal /tb_shifter/y_shifted
add wave -noupdate -color {Medium Orchid} /tb_shifter/shiftLorR
add wave -noupdate -color Blue /tb_shifter/cout
add wave -noupdate -radix unsigned /tb_shifter/x
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {87090 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {128 ns}
