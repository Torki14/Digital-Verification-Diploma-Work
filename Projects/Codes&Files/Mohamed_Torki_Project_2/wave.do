onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Assertions
add wave -noupdate /FIFO_top/DUT/FIFO_sva_inst/A_ALMOST_FULL
add wave -noupdate /FIFO_top/DUT/FIFO_sva_inst/A_RST_OVERFLOW
add wave -noupdate /FIFO_top/DUT/FIFO_sva_inst/A_RST_UNDERFLOW
add wave -noupdate /FIFO_top/DUT/FIFO_sva_inst/A_RST_WR_ACK
add wave -noupdate /FIFO_top/DUT/FIFO_sva_inst/A_UNDERFLOW_ASSERT
add wave -noupdate -divider {Inputs Signals}
add wave -noupdate /FIFO_top/fifoif/clk
add wave -noupdate /FIFO_top/fifoif/data_in
add wave -noupdate /FIFO_top/fifoif/rst_n
add wave -noupdate /FIFO_top/fifoif/wr_en
add wave -noupdate /FIFO_top/fifoif/rd_en
add wave -noupdate -divider {Combinational Outputs}
add wave -noupdate -color Cyan /FIFO_top/fifoif/empty
add wave -noupdate -color Cyan /uvm_root/uvm_test_top/env/sb/empty_ref
add wave -noupdate -color Violet /FIFO_top/fifoif/almostempty
add wave -noupdate -color Violet /uvm_root/uvm_test_top/env/sb/almostempty_ref
add wave -noupdate -color Coral /FIFO_top/fifoif/almostfull
add wave -noupdate -color Coral /uvm_root/uvm_test_top/env/sb/almostfull_ref
add wave -noupdate -color White /FIFO_top/fifoif/full
add wave -noupdate -color White /uvm_root/uvm_test_top/env/sb/full_ref
add wave -noupdate -divider {Sequential Outputs}
add wave -noupdate /FIFO_top/fifoif/wr_ack
add wave -noupdate /uvm_root/uvm_test_top/env/sb/wr_ack_ref
add wave -noupdate /FIFO_top/fifoif/overflow
add wave -noupdate /uvm_root/uvm_test_top/env/sb/overflow_ref
add wave -noupdate /FIFO_top/fifoif/underflow
add wave -noupdate /uvm_root/uvm_test_top/env/sb/underflow_ref
add wave -noupdate /FIFO_top/fifoif/data_out
add wave -noupdate /uvm_root/uvm_test_top/env/sb/data_out_ref
add wave -noupdate -divider {Internal Signals}
add wave -noupdate -radix decimal /uvm_root/uvm_test_top/env/sb/count
add wave -noupdate /uvm_root/uvm_test_top/env/sb/rd_ptr
add wave -noupdate /uvm_root/uvm_test_top/env/sb/wr_ptr
add wave -noupdate -divider {Other Signals}
add wave -noupdate /uvm_root/uvm_test_top/env/sb/mem
add wave -noupdate -radix decimal /uvm_root/uvm_test_top/env/sb/correct_count
add wave -noupdate -radix decimal /uvm_root/uvm_test_top/env/sb/error_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {89630 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {89568 ns} {89686 ns}
