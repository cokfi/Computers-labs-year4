onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IFE/clock
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IFE/reset
add wave -noupdate -divider Fetch
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/Instruction
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/PC_plus_4_out
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/Add_result
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/Branch
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/PC_out
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/PC
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/PC_plus_4
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/next_PC
add wave -noupdate -height 17 -group fetch -radix hexadecimal /mips_tb/U_0/IFE/Mem_Addr
add wave -noupdate -divider Decode
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/read_data_1
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/read_data_2
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/Instruction
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/read_data
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/ALU_result
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/RegWrite
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/MemtoReg
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/RegDst
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/Sign_extend
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/clock
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/reset
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/register_array
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/write_register_address
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/write_data
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/read_register_1_address
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/read_register_2_address
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/write_register_address_1
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/write_register_address_0
add wave -noupdate -height 17 -group decode -radix hexadecimal /mips_tb/U_0/ID/Instruction_immediate_value
add wave -noupdate -divider Execute
add wave -noupdate -height 17 -group execute /mips_tb/U_0/EXE/ALUoperation
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/Read_data_1
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/Read_data_2
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/Sign_extend
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/Function_opcode
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/ALUSrc
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/PC_plus_4
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/clock
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/reset
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/Ainput
add wave -noupdate -height 17 -group execute -radix hexadecimal /mips_tb/U_0/EXE/Binput
add wave -noupdate -height 17 -group execute /mips_tb/U_0/EXE/branchAddressResult
add wave -noupdate -height 17 -group execute /mips_tb/U_0/EXE/isBranchConditionTrue
add wave -noupdate -height 17 -group execute /mips_tb/U_0/EXE/ALUpreliminaryOutput
add wave -noupdate -height 17 -group execute /mips_tb/U_0/EXE/ALUresult
add wave -noupdate -divider Mem
add wave -noupdate -height 17 -group mem -radix hexadecimal /mips_tb/U_0/MEM/read_data
add wave -noupdate -height 17 -group mem -radix hexadecimal /mips_tb/U_0/MEM/address
add wave -noupdate -height 17 -group mem -radix hexadecimal /mips_tb/U_0/MEM/write_data
add wave -noupdate -height 17 -group mem -radix hexadecimal /mips_tb/U_0/MEM/MemRead
add wave -noupdate -height 17 -group mem -radix hexadecimal /mips_tb/U_0/MEM/Memwrite
add wave -noupdate -height 17 -group mem -radix hexadecimal /mips_tb/U_0/MEM/clock
add wave -noupdate -height 17 -group mem -radix hexadecimal /mips_tb/U_0/MEM/reset
add wave -noupdate -height 17 -group mem -radix hexadecimal /mips_tb/U_0/MEM/write_clock
add wave -noupdate -divider {Control Signals}
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/Opcode
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/RegDst
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/ALUSrc
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/MemtoReg
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/RegWrite
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/MemRead
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/MemWrite
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/Branch
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/Lw
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/Sw
add wave -noupdate -height 17 -group control -radix hexadecimal /mips_tb/U_0/CTL/Beq
add wave -noupdate -divider graphics
add wave -noupdate -height 17 -group graph /mips_tb/HEX0
add wave -noupdate -height 17 -group graph /mips_tb/HEX1
add wave -noupdate -height 17 -group graph /mips_tb/HEX2
add wave -noupdate -height 17 -group graph /mips_tb/HEX3
add wave -noupdate -height 17 -group graph /mips_tb/LEDG
add wave -noupdate -height 17 -group graph /mips_tb/LEDR
add wave -noupdate -height 17 -group graph /mips_tb/SW
add wave -noupdate -divider data_bus
add wave -noupdate -radix decimal /mips_tb/U_0/PERI/Data
add wave -noupdate -height 17 -group simulationsParameters /mips_tb/simulationMode
add wave -noupdate -height 17 -group simulationsParameters /mips_tb/addressLength
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {272450000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 189
configure wave -valuecolwidth 62
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
WaveRestoreZoom {246093750 ps} {278906250 ps}
