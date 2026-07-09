import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_test_pkg::*;

module FIFO_top();

    bit clk;
    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    FIFO_if fifoif(clk);

    FIFO DUT(
        .clk(fifoif.clk), 
        .rst_n(fifoif.rst_n),
        .wr_en(fifoif.wr_en), 
        .rd_en(fifoif.rd_en),
        .data_in(fifoif.data_in), 
        .data_out(fifoif.data_out),
        .wr_ack(fifoif.wr_ack), 
        .overflow(fifoif.overflow),
        .full(fifoif.full), 
        .empty(fifoif.empty),
        .almostfull(fifoif.almostfull), 
        .almostempty(fifoif.almostempty),
        .underflow(fifoif.underflow)
    );

    bind FIFO FIFO_sva FIFO_sva_inst (
        .clk         (fifoif.clk),
        .rst_n       (fifoif.rst_n),
        .wr_en       (fifoif.wr_en),
        .rd_en       (fifoif.rd_en),
        .data_in     (fifoif.data_in),
        .wr_ack      (fifoif.wr_ack),
        .overflow    (fifoif.overflow),
        .underflow   (fifoif.underflow),
        .full        (fifoif.full),
        .empty       (fifoif.empty),
        .almostfull  (fifoif.almostfull),
        .almostempty (fifoif.almostempty),
        .count       (count),      
        .wr_ptr      (wr_ptr),     
        .rd_ptr      (rd_ptr)      
    );

    initial begin
        uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "fifo_IF", fifoif);
        run_test("fifo_test");
    end

endmodule