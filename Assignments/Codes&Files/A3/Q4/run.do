vlib work
vlog my_mem.sv mem_tb.sv  +cover -covercells
vsim -voptargs=+acc work.mem_tb -cover
add wave *
coverage save mem_tb.ucdb -onexit
run -all
