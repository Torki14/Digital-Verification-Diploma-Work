interface FIFO_if (clk);
import shared_pkg::*;
    input bit clk;
    logic [FIFO_WIDTH-1:0] data_in, data_out;
    logic rst_n, wr_en, rd_en, wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
endinterface