interface FIFO_if(clk);

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;

    input logic clk;

    logic [FIFO_WIDTH-1:0] data_in, data_out;

    logic rst_n, wr_en, rd_en, wr_ack, overflow, full, empty, almostfull, almostempty, underflow;

    modport DUT (input clk, rst_n, wr_en, rd_en, data_in,
    output wr_ack, overflow, full, empty, almostfull, almostempty, underflow, data_out);

    modport TEST (input clk, wr_ack, overflow, full, empty, almostfull, almostempty, underflow, data_out,
    output rst_n, wr_en, rd_en, data_in);

    modport MONITOR (input clk, rst_n, wr_en, rd_en, data_in, 
    wr_ack, overflow, full, empty, almostfull, almostempty, underflow, data_out);
endinterface