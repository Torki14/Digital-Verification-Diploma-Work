package FIFO_scoreboard_pkg;
    import FIFO_transaction_pkg::*;
    import shared_pkg::*;

    class FIFO_scoreboard;

        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
	    localparam MAX_ADDR = $clog2(FIFO_DEPTH);

        bit [FIFO_WIDTH-1:0] data_out_ref;
        bit                  wr_ack_ref;
        bit                  overflow_ref;
        bit                  underflow_ref;
        bit                  full_ref;
        bit                  empty_ref;
        bit                  almostfull_ref;
        bit                  almostempty_ref;

        bit                  wr_ack_reg;
        bit                  overflow_reg;
        bit                  underflow_reg;
        bit [FIFO_WIDTH-1:0] data_out_reg;

        bit [FIFO_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
        
        logic [MAX_ADDR-1:0] wr_ptr, rd_ptr;

        int                  count;

        function new();
            wr_ptr         = 0;
            rd_ptr         = 0;
            count          = 0;
            data_out_ref   = '0;
            wr_ack_ref     = 1'b0;
            overflow_ref   = 1'b0;
            underflow_ref  = 1'b0;
            wr_ack_reg    = 1'b0;
            overflow_reg   = 1'b0;
            underflow_reg  = 1'b0;
            data_out_reg   = '0;
            full_ref       = 1'b0;
            empty_ref      = 1'b1;
            almostfull_ref = 1'b0;
            almostempty_ref= 1'b0;
        endfunction

        task check_data(FIFO_transaction F_txn);
            reference_model(F_txn);

            if (F_txn.rd_en && !F_txn.underflow) begin
                if (data_out_ref !== F_txn.data_out) begin
                    $display("Error at %t data_out mismatch: exp=0x%0h got=0x%0h",
                             $time, data_out_ref, F_txn.data_out);
                    error_count++;
                end
                else correct_count++;
            end

            if (wr_ack_ref !== F_txn.wr_ack) begin
                $display("Error at %t wr_ack mismatch: exp=%0b got=%0b",
                         $time, wr_ack_ref, F_txn.wr_ack);
                error_count++;
            end
            else correct_count++;

            if (overflow_ref !== F_txn.overflow) begin
                $display("Error at %t overflow mismatch: exp=%0b got=%0b",
                         $time, overflow_ref, F_txn.overflow);
                error_count++;
            end
            else correct_count++;

            if (underflow_ref !== F_txn.underflow) begin
                $display("Error at %t underflow mismatch: exp=%0b got=%0b",
                         $time, underflow_ref, F_txn.underflow);
                error_count++;
            end
            else correct_count++;

            if (full_ref !== F_txn.full) begin
                $display("Error at %t full mismatch: exp=%0b got=%0b",
                         $time, full_ref, F_txn.full);
                error_count++;
            end
            else correct_count++;

            if (empty_ref !== F_txn.empty) begin
                $display("Error at %t empty mismatch: exp=%0b got=%0b",
                         $time, empty_ref, F_txn.empty);
                error_count++;
            end
            else correct_count++;

            if (almostfull_ref !== F_txn.almostfull) begin
                $display("Error at %t almostfull mismatch: exp=%0b got=%0b (count=%0d)",
                         $time, almostfull_ref, F_txn.almostfull, count);
                error_count++;
            end
            else correct_count++;

            if (almostempty_ref !== F_txn.almostempty) begin
                $display("Error at %t almostempty mismatch: exp=%0b got=%0b",
                         $time, almostempty_ref, F_txn.almostempty);
                error_count++;
            end
            else correct_count++;
        endtask

        task reference_model(FIFO_transaction F_txn);
            bit [FIFO_WIDTH-1:0] data_out_next;

            if (!F_txn.rst_n) begin
                wr_ptr         = 0;
                rd_ptr         = 0;
                count          = 0;
                data_out_ref   = 0;
                wr_ack_ref     = 0;
                overflow_ref   = 0;
                underflow_ref  = 0;
                wr_ack_reg    = 0;
                overflow_reg   = 0;
                underflow_reg  = 0;
                data_out_reg   = 0;
                full_ref       = 0;
                empty_ref      = 1;
                almostfull_ref = 0;
                almostempty_ref= 0;
            end
            else begin
                full_ref        = (count == FIFO_DEPTH);
                empty_ref       = (count == 0);
                almostfull_ref   = (count == FIFO_DEPTH - 1);
                almostempty_ref  = (count == 1);

                wr_ack_ref     = wr_ack_reg;
                overflow_ref   = overflow_reg;
                underflow_ref  = underflow_reg;
                data_out_ref   = data_out_reg;

                wr_ack_reg    = 0;
                overflow_reg  = 0;
                underflow_reg = 0;
                data_out_next  = data_out_reg;

                if (F_txn.wr_en && count < FIFO_DEPTH) begin
                    mem[wr_ptr] = F_txn.data_in;
                    wr_ack_reg  = 1;
                    wr_ptr = wr_ptr + 1;
                end
                else begin
                    if (full_ref && F_txn.wr_en)
                        overflow_reg = 1;
                    else
                        overflow_reg = 0;
                end

                if (F_txn.rd_en && count != 0) begin
                    data_out_next = mem[rd_ptr];
                    rd_ptr = rd_ptr + 1;
                end
                else begin
                    if (F_txn.rd_en && empty_ref)
                        underflow_reg = 1;
                    else
                        underflow_reg = 0;
                end

                if (F_txn.wr_en && F_txn.rd_en) begin
                    if (empty_ref)
                        count = count + 1; 
                    else if (full_ref)
                        count = count - 1;
                end
                else if (F_txn.wr_en && !full_ref)
                    count = count + 1;
                else if (F_txn.rd_en && !empty_ref)
                    count = count - 1;

                data_out_reg   = data_out_next;

            end
        endtask
    endclass

endpackage