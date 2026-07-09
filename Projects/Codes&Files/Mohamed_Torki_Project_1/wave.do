onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FIFO_top/A_TOP_RST_OVERFLOW
add wave -noupdate /FIFO_top/A_TOP_RST_UNDERFLOW
add wave -noupdate /FIFO_top/A_TOP_RST_WR_ACK
add wave -noupdate /FIFO_top/DUT/A_ALMOST_FULL
add wave -noupdate /FIFO_top/DUT/A_RST_OVERFLOW
add wave -noupdate /FIFO_top/DUT/A_RST_UNDERFLOW
add wave -noupdate /FIFO_top/DUT/A_RST_WR_ACK
add wave -noupdate /FIFO_top/DUT/A_UNDERFLOW
add wave -noupdate -divider Inputs
add wave -noupdate /FIFO_top/fifoif/clk
add wave -noupdate -color Violet /FIFO_top/fifoif/rst_n
add wave -noupdate -color Cyan /FIFO_top/fifoif/wr_en
add wave -noupdate /FIFO_top/fifoif/rd_en
add wave -noupdate -color Yellow /FIFO_top/fifoif/data_in
add wave -noupdate -divider {Combinational Outputs}
add wave -noupdate -color Orange /FIFO_top/fifoif/empty
add wave -noupdate -color Orange /FIFO_top/MONITOR/fifo_sb.empty_ref
add wave -noupdate -color Violet /FIFO_top/fifoif/almostempty
add wave -noupdate -color Violet /FIFO_top/MONITOR/fifo_sb.almostempty_ref
add wave -noupdate -color Cyan /FIFO_top/fifoif/almostfull
add wave -noupdate -color Cyan /FIFO_top/MONITOR/fifo_sb.almostfull_ref
add wave -noupdate /FIFO_top/fifoif/full
add wave -noupdate /FIFO_top/MONITOR/fifo_sb.full_ref
add wave -noupdate -divider {Sequential Outputs}
add wave -noupdate /FIFO_top/fifoif/wr_ack
add wave -noupdate /FIFO_top/MONITOR/fifo_sb.wr_ack_ref
add wave -noupdate -color Orange /FIFO_top/fifoif/underflow
add wave -noupdate -color Orange /FIFO_top/MONITOR/fifo_sb.underflow_ref
add wave -noupdate /FIFO_top/fifoif/overflow
add wave -noupdate /FIFO_top/MONITOR/fifo_sb.overflow_ref
add wave -noupdate /FIFO_top/fifoif/data_out
add wave -noupdate /FIFO_top/MONITOR/fifo_sb.data_out_ref
add wave -noupdate -divider {Internal signals}
add wave -noupdate /FIFO_top/DUT/count
add wave -noupdate /FIFO_top/MONITOR/fifo_sb.count
add wave -noupdate /FIFO_top/DUT/mem
add wave -noupdate /FIFO_top/MONITOR/fifo_sb.mem
add wave -noupdate /FIFO_top/DUT/wr_ptr
add wave -noupdate /FIFO_top/MONITOR/fifo_sb.wr_ptr
add wave -noupdate /FIFO_top/DUT/rd_ptr
add wave -noupdate /FIFO_top/MONITOR/fifo_sb.rd_ptr
add wave -noupdate -divider {Other Signals}
add wave -noupdate /FIFO_top/MONITOR/fifo_sb
add wave -noupdate /FIFO_top/MONITOR/fifo_mon_txn
add wave -noupdate /FIFO_top/MONITOR/fifo_cov
add wave -noupdate -radix decimal /shared_pkg::correct_count
add wave -noupdate -radix decimal /shared_pkg::error_count
add wave -noupdate /shared_pkg::test_finished
add wave -noupdate /shared_pkg::sample_event
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
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
WaveRestoreZoom {0 ns} {59 ns}
