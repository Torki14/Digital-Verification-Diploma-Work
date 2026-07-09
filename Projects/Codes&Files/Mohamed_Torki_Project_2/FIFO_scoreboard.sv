package fifo_scoreboard_pkg;
import fifo_sequence_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)

        uvm_analysis_export #(fifo_sequence_item) sb_export;
        uvm_tlm_analysis_fifo #(fifo_sequence_item) sb_fifo;
        fifo_sequence_item seq_item_sb;

        // Reference Model Signals
        localparam MAX_ADDR   = $clog2(FIFO_DEPTH);

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

        int count         = 0;
        int error_count   = 0;
        int correct_count = 0;

        function new(string name = "fifo_scoreboard", uvm_component parent = null);
            super.new(name, parent);
            wr_ptr          = 0;
            rd_ptr          = 0;
            count           = 0;
            data_out_ref    = '0;
            wr_ack_ref      = 1'b0;
            overflow_ref    = 1'b0;
            underflow_ref   = 1'b0;
            wr_ack_reg      = 1'b0;
            overflow_reg    = 1'b0;
            underflow_reg   = 1'b0;
            data_out_reg    = '0;
            full_ref        = 1'b0;
            empty_ref       = 1'b1;
            almostfull_ref  = 1'b0;
            almostempty_ref = 1'b0;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo   = new("sb_fifo",   this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);

                if (seq_item_sb.rd_en && !seq_item_sb.underflow) begin
                    if (data_out_ref !== seq_item_sb.data_out) begin
                        `uvm_error("run_phase",
                            $sformatf("data_out Mismatch: exp=0x%0h got=0x%0h | %s",
                                      data_out_ref, seq_item_sb.data_out,
                                      seq_item_sb.convert2string()))
                        error_count++;
                    end else begin
                        `uvm_info("run_phase",
                            $sformatf("data_out Correct: 0x%0h | %s",
                                      seq_item_sb.data_out,
                                      seq_item_sb.convert2string()), UVM_HIGH)
                        correct_count++;
                    end
                end

                if (wr_ack_ref !== seq_item_sb.wr_ack) begin
                    `uvm_error("run_phase",
                        $sformatf("wr_ack Mismatch: exp=%0b got=%0b | %s",
                                  wr_ack_ref, seq_item_sb.wr_ack,
                                  seq_item_sb.convert2string()))
                    error_count++;
                end else correct_count++;

                if (overflow_ref !== seq_item_sb.overflow) begin
                    `uvm_error("run_phase",
                        $sformatf("overflow Mismatch: exp=%0b got=%0b | %s",
                                  overflow_ref, seq_item_sb.overflow,
                                  seq_item_sb.convert2string()))
                    error_count++;
                end else correct_count++;

                if (underflow_ref !== seq_item_sb.underflow) begin
                    `uvm_error("run_phase",
                        $sformatf("underflow Mismatch: exp=%0b got=%0b | %s",
                                  underflow_ref, seq_item_sb.underflow,
                                  seq_item_sb.convert2string()))
                    error_count++;
                end else correct_count++;

                if (full_ref !== seq_item_sb.full) begin
                    `uvm_error("run_phase",
                        $sformatf("full Mismatch: exp=%0b got=%0b | %s",
                                  full_ref, seq_item_sb.full,
                                  seq_item_sb.convert2string()))
                    error_count++;
                end else correct_count++;

                if (empty_ref !== seq_item_sb.empty) begin
                    `uvm_error("run_phase",
                        $sformatf("empty Mismatch: exp=%0b got=%0b | %s",
                                  empty_ref, seq_item_sb.empty,
                                  seq_item_sb.convert2string()))
                    error_count++;
                end else correct_count++;

                if (almostfull_ref !== seq_item_sb.almostfull) begin
                    `uvm_error("run_phase",
                        $sformatf("almostfull Mismatch: exp=%0b got=%0b (count=%0d) | %s",
                                  almostfull_ref, seq_item_sb.almostfull, count,
                                  seq_item_sb.convert2string()))
                    error_count++;
                end else correct_count++;

                if (almostempty_ref !== seq_item_sb.almostempty) begin
                    `uvm_error("run_phase",
                        $sformatf("almostempty Mismatch: exp=%0b got=%0b | %s",
                                  almostempty_ref, seq_item_sb.almostempty,
                                  seq_item_sb.convert2string()))
                    error_count++;
                end else correct_count++;
            end
        endtask

task ref_model(fifo_sequence_item seq_item_chk);
            bit [FIFO_WIDTH-1:0] data_out_next;

            if (!seq_item_chk.rst_n) begin
                wr_ptr          = 0;
                rd_ptr          = 0;
                count           = 0;
                data_out_ref    = 0;
                wr_ack_ref      = 0;
                overflow_ref    = 0;
                underflow_ref   = 0;
                full_ref        = 0;
                empty_ref       = 1;
                almostfull_ref  = 0;
                almostempty_ref = 0;
            end
            else begin
                if (seq_item_chk.wr_en && count < FIFO_DEPTH) begin
                    mem[wr_ptr] = seq_item_chk.data_in;
                    wr_ack_ref  = 1;
                    wr_ptr      = (wr_ptr + 1) % FIFO_DEPTH; 
                    overflow_ref = 0;
                end
                else begin
                    wr_ack_ref = 0;
                    if (full_ref && seq_item_chk.wr_en)
                        overflow_ref = 1;
                    else
                        overflow_ref = 0;
                end

                if (seq_item_chk.rd_en && count != 0) begin
                    data_out_ref  = mem[rd_ptr];
                    rd_ptr        = (rd_ptr + 1) % FIFO_DEPTH; 
                    underflow_ref = 0;
                end
                else begin
                    if (seq_item_chk.rd_en && empty_ref)
                        underflow_ref = 1;
                    else
                        underflow_ref = 0;
                end

                if (seq_item_chk.wr_en && seq_item_chk.rd_en) begin
                    if (empty_ref)
                        count = count + 1;
                    else if (full_ref)
                        count = count - 1;
                end
                else if (seq_item_chk.wr_en && !full_ref)
                    count = count + 1;
                else if (seq_item_chk.rd_en && !empty_ref)
                    count = count - 1;

                full_ref        = (count == FIFO_DEPTH);
                empty_ref       = (count == 0);
                almostfull_ref  = (count == FIFO_DEPTH - 1);
                almostempty_ref = (count == 1);
            end
        endtask
        
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("Report Phase",
                $sformatf("Total Successful Transactions = %0d", correct_count), UVM_MEDIUM)
            `uvm_info("Report Phase",
                $sformatf("Total Failed Transactions    = %0d", error_count),   UVM_MEDIUM)
        endfunction

    endclass
endpackage