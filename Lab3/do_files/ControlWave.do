onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {external signals} /tbcontrol/rst
add wave -noupdate -expand -group {external signals} /tbcontrol/L1/clk
add wave -noupdate -expand -group {external signals} /tbcontrol/Opcode
add wave -noupdate -expand -group {external signals} /tbcontrol/ALUctl
add wave -noupdate -expand -group {external signals} -group flags /tbcontrol/Cflag
add wave -noupdate -expand -group {external signals} -group flags /tbcontrol/Nflag
add wave -noupdate -expand -group {external signals} -group flags /tbcontrol/Zflag
add wave -noupdate -expand -group {external signals} -group flags /tbcontrol/clk
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/Ain
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/Cin
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/Cout
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/IRin
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/PCin
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/PCsel
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/RFOut
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/RFaddr
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/immIn
add wave -noupdate -expand -group {external signals} -group ctl /tbcontrol/wrRFenable
add wave -noupdate -expand -group {external signals} -group generic /tbcontrol/Dwidth
add wave -noupdate -expand -group {external signals} -group generic /tbcontrol/n
add wave -noupdate -expand -group {external signals} /tbcontrol/tbDone
add wave -noupdate -expand -group {Control internal signals} /tbcontrol/L1/next_state
add wave -noupdate -expand -group {Control internal signals} /tbcontrol/L1/state
add wave -noupdate -expand -group {Control internal signals} /tbcontrol/L1/tbDone
add wave -noupdate -expand -group instruction /tbcontrol/L1/add
add wave -noupdate -expand -group instruction /tbcontrol/L1/sub
add wave -noupdate -expand -group instruction /tbcontrol/L1/nop
add wave -noupdate -expand -group instruction /tbcontrol/L1/jmp
add wave -noupdate -expand -group instruction /tbcontrol/L1/jc
add wave -noupdate -expand -group instruction /tbcontrol/L1/jnc
add wave -noupdate -expand -group instruction /tbcontrol/L1/mov
add wave -noupdate -expand -group instruction /tbcontrol/L1/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50639 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 179
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
WaveRestoreZoom {0 ps} {180915 ps}
