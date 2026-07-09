import shared_pkg::*;   
import FIFO_transaction_pkg::*;    
import FIFO_coverage_pkg::*;    
import FIFO_scoreboard_pkg::*;   
module FIFO_monitor(FIFO_if.MONITOR mon_if);
 
    FIFO_transaction fifo_mon_txn;
    FIFO_coverage    fifo_cov;
    FIFO_scoreboard   fifo_sb;

    initial begin
        fifo_mon_txn = new();
        fifo_cov     = new();
        fifo_sb      = new();
        forever begin
            @(sample_event);
            fifo_mon_txn.rst_n = mon_if.rst_n;
            fifo_mon_txn.wr_en = mon_if.wr_en;
            fifo_mon_txn.rd_en = mon_if.rd_en;
            fifo_mon_txn.data_in = mon_if.data_in;
            fifo_mon_txn.wr_ack = mon_if.wr_ack;
            fifo_mon_txn.overflow = mon_if.overflow;
            fifo_mon_txn.full = mon_if.full;
            fifo_mon_txn.empty = mon_if.empty;
            fifo_mon_txn.almostfull = mon_if.almostfull;
            fifo_mon_txn.almostempty = mon_if.almostempty;
            fifo_mon_txn.underflow = mon_if.underflow;
            fifo_mon_txn.data_out = mon_if.data_out;
            fork 
                begin: Coverage_Collector
                    fifo_cov.sample_data(fifo_mon_txn);
                end

                begin: Scoreboard
                    fifo_sb.check_data(fifo_mon_txn);
                end
            join

            if (test_finished == 1'b1) begin
            $display("==================================================");
            $display("                 SIMULATION FINISHED              ");
            $display("==================================================");
            $display(" Total Correct Transactions : %0d", correct_count);
            $display(" Total Error Transactions   : %0d", error_count);
            $display("==================================================");
            $stop; 
            end
        end
    end
endmodule