onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbtop/clk
add wave -noupdate -color Firebrick /tbtop/rst
add wave -noupdate /tbtop/topInst/Control_inst/state
add wave -noupdate -color {Violet Red} /tbtop/enable
add wave -noupdate -color Cyan /tbtop/TBactive
add wave -noupdate -color {Orange Red} /tbtop/done
add wave -noupdate -group TB -radix hexadecimal /tbtop/MEMdataIn
add wave -noupdate -group TB /tbtop/MEMgeneratorFileLocation
add wave -noupdate -group TB -radix hexadecimal /tbtop/MEMwriteAddress
add wave -noupdate -group TB /tbtop/MEMwriteEnable
add wave -noupdate -group TB /tbtop/RFdataIn
add wave -noupdate -group TB /tbtop/RFreadAddress
add wave -noupdate -group TB /tbtop/RFwriteAddress
add wave -noupdate -group TB /tbtop/RFwriteEnable
add wave -noupdate -group TB /tbtop/fileGen
add wave -noupdate -group TB /tbtop/initFilesIsDone
add wave -noupdate -expand -group {instruction type} /tbtop/topInst/Control_inst/add
add wave -noupdate -expand -group {instruction type} /tbtop/topInst/Control_inst/jc
add wave -noupdate -expand -group {instruction type} /tbtop/topInst/Control_inst/jmp
add wave -noupdate -expand -group {instruction type} /tbtop/topInst/Control_inst/jnc
add wave -noupdate -expand -group {instruction type} /tbtop/topInst/Control_inst/mov
add wave -noupdate -expand -group {instruction type} /tbtop/topInst/Control_inst/nop
add wave -noupdate -expand -group {instruction type} /tbtop/topInst/Control_inst/sub
add wave -noupdate -expand -group DATApath -radix hexadecimal /tbtop/topInst/DataPath_inst/ALUOut
add wave -noupdate -expand -group DATApath /tbtop/topInst/DataPath_inst/ALUctl
add wave -noupdate -expand -group DATApath /tbtop/topInst/DataPath_inst/Ain
add wave -noupdate -expand -group DATApath -radix hexadecimal /tbtop/topInst/DataPath_inst/IR
add wave -noupdate -expand -group DATApath -radix hexadecimal /tbtop/topInst/DataPath_inst/PC
add wave -noupdate -expand -group DATApath -radix hexadecimal /tbtop/topInst/DataPath_inst/dataBus
add wave -noupdate -group RF /tbtop/topInst/DataPath_inst/TBwriteRFenable
add wave -noupdate -group RF -radix hexadecimal /tbtop/RFdataOut
add wave -noupdate -group RF -radix hexadecimal /tbtop/topInst/DataPath_inst/RFaddrFromIR
add wave -noupdate -group RF -radix hexadecimal /tbtop/topInst/DataPath_inst/RFdataOut
add wave -noupdate -group RF -radix hexadecimal /tbtop/topInst/DataPath_inst/RFreadAddr
add wave -noupdate -group RF -radix hexadecimal /tbtop/topInst/DataPath_inst/RFwriteAddr
add wave -noupdate -group RF -radix hexadecimal /tbtop/topInst/DataPath_inst/RFdataIn
add wave -noupdate -group RF /tbtop/topInst/DataPath_inst/RFwriteEnable
add wave -noupdate -group control /tbtop/topInst/Opcode
add wave -noupdate -group control /tbtop/topInst/ALUctl
add wave -noupdate -group control /tbtop/topInst/Ain
add wave -noupdate -group control /tbtop/topInst/Cflag
add wave -noupdate -group control /tbtop/topInst/Cin
add wave -noupdate -group control /tbtop/topInst/Cout
add wave -noupdate -group control /tbtop/topInst/Dwidth
add wave -noupdate -group control /tbtop/topInst/IRin
add wave -noupdate -group control /tbtop/topInst/Nflag
add wave -noupdate -group control /tbtop/topInst/PCin
add wave -noupdate -group control /tbtop/topInst/PCsel
add wave -noupdate -group control /tbtop/topInst/RFOut
add wave -noupdate -group control /tbtop/topInst/Zflag
add wave -noupdate -group control /tbtop/topInst/done
add wave -noupdate -group control /tbtop/topInst/immIn
add wave -noupdate -group control /tbtop/topInst/wrRFenable
add wave -noupdate -group MEM -radix hexadecimal /tbtop/MEMdataIn
add wave -noupdate -group MEM /tbtop/MEMwriteEnable
add wave -noupdate -group MEM /tbtop/topInst/DataPath_inst/wrEn
add wave -noupdate -group MEM /tbtop/topInst/DataPath_inst/TBactive
add wave -noupdate -group MEM /tbtop/topInst/DataPath_inst/PM_dataOut
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/ALUctl
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/Ain
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/Cin
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/Cout
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/IRin
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/PCin
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/PCsel
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/RFOut
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/RFaddr
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/immIn
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/tbDone
add wave -noupdate -group controlOut /tbtop/topInst/Control_inst/wrRFenable
add wave -noupdate -group PC /tbtop/topInst/DataPath_inst/PC
add wave -noupdate -group PC /tbtop/topInst/DataPath_inst/PCin
add wave -noupdate -group PC /tbtop/topInst/DataPath_inst/PCinput
add wave -noupdate -group PC /tbtop/topInst/DataPath_inst/PCplusImmadiatePlusOne
add wave -noupdate -group PC /tbtop/topInst/DataPath_inst/PCplusOne
add wave -noupdate -group PC /tbtop/topInst/DataPath_inst/PCplusOneExtended
add wave -noupdate -group PC /tbtop/topInst/DataPath_inst/PCsel
add wave -noupdate -group PC /tbtop/topInst/DataPath_inst/PM_dataOut
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/ALUOut
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/ALUResult
add wave -noupdate -height 17 -expand -group ALU /tbtop/topInst/DataPath_inst/ALU_Connect/ALUctl
add wave -noupdate -height 17 -expand -group ALU /tbtop/topInst/DataPath_inst/ALU_Connect/Ain
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/Ainput
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/Binput
add wave -noupdate -height 17 -expand -group ALU /tbtop/topInst/DataPath_inst/ALU_Connect/Cflag
add wave -noupdate -height 17 -expand -group ALU /tbtop/topInst/DataPath_inst/ALU_Connect/Cin
add wave -noupdate -height 17 -expand -group ALU /tbtop/topInst/DataPath_inst/ALU_Connect/Nflag
add wave -noupdate -height 17 -expand -group ALU /tbtop/topInst/DataPath_inst/ALU_Connect/Zflag
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/adderSubResult
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/operandA
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/operandB
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/regA
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/regC
add wave -noupdate -height 17 -expand -group ALU -radix hexadecimal /tbtop/topInst/DataPath_inst/ALU_Connect/regCout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1700000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 345
configure wave -valuecolwidth 171
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
WaveRestoreZoom {446862 ps} {4187008 ps}
