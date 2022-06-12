onerror {resume}
add list -width 17 /tb_addsub/sctr
add list /tb_addsub/cout
add list /tb_addsub/y
add list /tb_addsub/x
add list /tb_addsub/s
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
