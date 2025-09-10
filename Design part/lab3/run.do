# vlib wrok
# vlog dff_en_pre.v dff_en_pre_tb.v
# vsim -voptargs=+acc work.dff_en_pre_tb
# add wave *
# run -all
# quit -sim

vlib wrok

# Compile Design and Testbenches
vlog param_FF.v
vlog D_FF.v
vlog T_FF.v
vlog param_FF_tb1.v
vlog param_FF_tb2.v

# Run Testbench 1 (DFF mode)
vsim -voptargs=+acc param_ff_tb1
add wave *
run -all
quit

# Run Testbench 2 (TFF mode)
vsim -voptargs=+acc param_FF_tb2
add wave *
run -all
quit
