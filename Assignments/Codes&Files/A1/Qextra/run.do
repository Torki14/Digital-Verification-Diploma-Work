vlib work
vlog dff.v dff_t2_tb.sv  +cover -covercells
vsim -voptargs=+acc work.dff_t2_tb -cover
add wave *
coverage save dff_t2_tb.ucdb -onexit
run -all