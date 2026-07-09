package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;    
    class FIFO_coverage;
    
        FIFO_transaction F_cvg_txn;
        
        //FIFO_13
        covergroup cov_grp;
            wr_en_cp      : coverpoint F_cvg_txn.wr_en;
            rd_en_cp      : coverpoint F_cvg_txn.rd_en;
            wr_ack_cp     : coverpoint F_cvg_txn.wr_ack;
            overflow_cp   : coverpoint F_cvg_txn.overflow;
            full_cp       : coverpoint F_cvg_txn.full;
            empty_cp      : coverpoint F_cvg_txn.empty;
            almostfull_cp : coverpoint F_cvg_txn.almostfull;
            almostempty_cp: coverpoint F_cvg_txn.almostempty;
            underflow_cp  : coverpoint F_cvg_txn.underflow;

            cross wr_en_cp, rd_en_cp, wr_ack_cp;
            cross wr_en_cp, rd_en_cp, overflow_cp;
            cross wr_en_cp, rd_en_cp, full_cp;
            cross wr_en_cp, rd_en_cp, empty_cp;
            cross wr_en_cp, rd_en_cp, almostfull_cp;
            cross wr_en_cp, rd_en_cp, almostempty_cp;
            cross wr_en_cp, rd_en_cp, underflow_cp;
        endgroup

        function new();
            cov_grp = new();
        endfunction

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            cov_grp.sample();
        endfunction
    endclass
endpackage