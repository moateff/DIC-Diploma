vlib work
vlog -f src_files.list +cover -covercells 
vsim -voptargs=+acc work.fifo_top -cover -classdebug -uvmcontrol=all
add wave /fifo_top/fifoif/*
coverage save FIFO_tb.ucdb -onexit
run -all
# quit -sim
# vcover report FIFO_tb.ucdb -details -annotate -all -output FIFO_coverage_rpt.txt