vlib work
vlog testing_pkg.sv alu_seq.sv tb.sv  +cover -covercells
vsim -voptargs=+acc work.tb -cover
add wave *
coverage save tb.ucdb -onexit
run -all
coverage exclude -du tb -togglenode opcode
coverage exclude -src alu_seq.sv -line 17 -code b
coverage exclude -src alu_seq.sv -line 17 -code s
