vlib work
vlog -f src_files.list
vsim -voptargs=+acc work.shift_reg_top -classdebug -uvmcontrol=all
add wave /shift_reg_top/shift_regif/*
run -all