vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.alsu_tb -cover -classdebug -uvmcontrol=all
add wave /alsu_tb/alsuif/*
coverage save ALSU_tb.ucdb -onexit
run -all
# quit -sim
# vcover report ALSU_tb.ucdb -details -annotate -all -output ALSU_coverage_rpt.txt