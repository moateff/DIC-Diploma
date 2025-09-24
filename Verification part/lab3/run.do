vlog ALSU_pkg.sv
vlog ALSU_golden.v
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit
run -all
# quit -sim
# vcover report ALSU_tb.ucdb -details -annotate -all -output coverage_rpt.txt