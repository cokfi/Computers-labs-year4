onerror {resume}
add list -width 19 /tb_logical/ALUFN
add list /tb_logical/x
add list /tb_logical/y
add list /tb_logical/result
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
