vlib work
vlog *v +cover -covercells
vsim -voptargs=+acc work.counter_top -cover
add wave *
coverage save counter_top.ucdb -onexit
run -all
