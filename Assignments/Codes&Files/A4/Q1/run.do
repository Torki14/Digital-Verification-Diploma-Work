vlib work
vlog ALSU_pkg.sv ALSU_GM.v ALSU.v ALSU_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit
run -all
coverage exclude -du ALSU -togglenode {cin_reg[1]}
