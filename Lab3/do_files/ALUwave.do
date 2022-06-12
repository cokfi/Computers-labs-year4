onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB -radix decimal /tbalu/x
add wave -noupdate -expand -group TB -radix decimal /tbalu/y
add wave -noupdate -expand -group TB -radix decimal /tbalu/ALUOut
add wave -noupdate -expand -group TB /tbalu/ALUctl
add wave -noupdate -expand -group TB -color Aquamarine /tbalu/Cflag
add wave -noupdate -expand -group TB -color {Violet Red} /tbalu/Nflag
add wave -noupdate -expand -group TB -color Cyan /tbalu/Zflag
add wave -noupdate -expand -group TB /tbalu/Ain
add wave -noupdate -expand -group TB /tbalu/Cin
add wave -noupdate -expand -group TB /tbalu/Dwidth
add wave -noupdate -expand -group TB /tbalu/clk
add wave -noupdate -expand -group TB -radix decimal /tbalu/dataBus
add wave -noupdate -expand -group TB /tbalu/n
add wave -noupdate -expand -group TB /tbalu/rst
add wave -noupdate -expand -group ALU -radix hexadecimal /tbalu/L0/ALUResult
add wave -noupdate -expand -group ALU -radix hexadecimal /tbalu/L0/Ainput
add wave -noupdate -expand -group ALU -radix hexadecimal -childformat {{/tbalu/L0/Binput(15) -radix hexadecimal} {/tbalu/L0/Binput(14) -radix hexadecimal} {/tbalu/L0/Binput(13) -radix hexadecimal} {/tbalu/L0/Binput(12) -radix hexadecimal} {/tbalu/L0/Binput(11) -radix hexadecimal} {/tbalu/L0/Binput(10) -radix hexadecimal} {/tbalu/L0/Binput(9) -radix hexadecimal} {/tbalu/L0/Binput(8) -radix hexadecimal} {/tbalu/L0/Binput(7) -radix hexadecimal} {/tbalu/L0/Binput(6) -radix hexadecimal} {/tbalu/L0/Binput(5) -radix hexadecimal} {/tbalu/L0/Binput(4) -radix hexadecimal} {/tbalu/L0/Binput(3) -radix hexadecimal} {/tbalu/L0/Binput(2) -radix hexadecimal} {/tbalu/L0/Binput(1) -radix hexadecimal} {/tbalu/L0/Binput(0) -radix hexadecimal}} -subitemconfig {/tbalu/L0/Binput(15) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(14) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(13) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(12) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(11) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(10) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(9) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(8) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(7) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(6) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(5) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(4) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(3) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(2) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(1) {-height 15 -radix hexadecimal} /tbalu/L0/Binput(0) {-height 15 -radix hexadecimal}} /tbalu/L0/Binput
add wave -noupdate -expand -group ALU /tbalu/L0/Cflag
add wave -noupdate -expand -group ALU -radix hexadecimal /tbalu/L0/operandA
add wave -noupdate -expand -group ALU -radix hexadecimal /tbalu/L0/operandB
add wave -noupdate -expand -group ALU -radix hexadecimal /tbalu/L0/regA
add wave -noupdate -expand -group ALU -radix hexadecimal /tbalu/L0/regC
add wave -noupdate -height 17 -expand -group adder -radix hexadecimal /tbalu/L0/AdderSubtractorInst/a
add wave -noupdate -height 17 -expand -group adder -radix hexadecimal /tbalu/L0/AdderSubtractorInst/b
add wave -noupdate -height 17 -expand -group adder -radix hexadecimal /tbalu/L0/AdderSubtractorInst/bPreXor
add wave -noupdate -height 17 -expand -group adder -radix hexadecimal /tbalu/L0/AdderSubtractorInst/carry
add wave -noupdate -height 17 -expand -group adder /tbalu/L0/AdderSubtractorInst/cin
add wave -noupdate -height 17 -expand -group adder /tbalu/L0/AdderSubtractorInst/cout
add wave -noupdate -height 17 -expand -group adder -radix hexadecimal /tbalu/L0/adderSubResult
add wave -noupdate -height 17 -expand -group adder -radix hexadecimal /tbalu/L0/AdderSubtractorInst/s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {150000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
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
WaveRestoreZoom {0 ps} {4551282 ps}
