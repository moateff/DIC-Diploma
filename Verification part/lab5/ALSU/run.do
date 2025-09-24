vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.alsu_tb -classdebug -uvmcontrol=all
add wave /alsu_tb/alsuif/*
run -all