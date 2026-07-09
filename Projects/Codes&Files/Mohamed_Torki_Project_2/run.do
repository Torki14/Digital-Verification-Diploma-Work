quit -sim
if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vlog -f src_files.list -mfcu +cover
vsim -voptargs=+acc -coverage work.FIFO_top
set NoQuitOnFinish 1
onbreak {resume}
run 0
do wave.do
coverage save FIFO.ucdb -onexit
run -all