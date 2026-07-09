vlib work
vlog *.*v +cover -covercells +define+SIM
vsim -voptargs=+acc work.FIFO_top -classdebug -cover
add wave \
    /FIFO_top/A_TOP_RST_OVERFLOW \
    /FIFO_top/A_TOP_RST_UNDERFLOW \
    /FIFO_top/A_TOP_RST_WR_ACK \
    /FIFO_top/DUT/A_ALMOST_FULL \
    /FIFO_top/DUT/A_RST_OVERFLOW \
    /FIFO_top/DUT/A_RST_UNDERFLOW \
    /FIFO_top/DUT/A_RST_WR_ACK \
    /FIFO_top/DUT/A_UNDERFLOW   
run 0
do wave.do
coverage save FIFO.ucdb -onexit
run -all