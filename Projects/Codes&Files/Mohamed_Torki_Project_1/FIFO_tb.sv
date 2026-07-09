import shared_pkg::*;   
import FIFO_transaction_pkg::*;
module FIFO_tb(FIFO_if.TEST fifo_if);
    
    FIFO_transaction txn;
    
    //FIFO_15
    initial begin
        correct_count = 0;
        error_count = 0;
        test_finished = 0;

        txn = new();
        fifo_if.rst_n = 0;
        fifo_if.data_in = 0;
        fifo_if.wr_en = 0; 
        fifo_if.rd_en = 0;

        @(negedge fifo_if.clk);
        fifo_if.rst_n = 1;

        repeat(10000)begin
            assert(txn.randomize());
            fifo_if.data_in = txn.data_in;
            fifo_if.rst_n = txn.rst_n;
            fifo_if.wr_en = txn.wr_en;
            fifo_if.rd_en = txn.rd_en;
            
            #1; //Give the data the chance to settle
            ->sample_event;
            @(negedge fifo_if.clk);
        end
        test_finished = 1;
        ->sample_event;
    end

endmodule