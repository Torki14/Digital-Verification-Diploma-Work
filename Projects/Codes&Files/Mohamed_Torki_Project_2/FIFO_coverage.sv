package fifo_coverage_pkg;
import fifo_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class fifo_coverage extends uvm_component;
        `uvm_component_utils(fifo_coverage)
        fifo_sequence_item cov_seq_item;
        uvm_analysis_export #(fifo_sequence_item) cov_export;
        uvm_tlm_analysis_fifo #(fifo_sequence_item) cov_fifo;

        covergroup cov_grp;
            wr_en_cp      : coverpoint cov_seq_item.wr_en;
            rd_en_cp      : coverpoint cov_seq_item.rd_en;
            wr_ack_cp     : coverpoint cov_seq_item.wr_ack;
            overflow_cp   : coverpoint cov_seq_item.overflow;
            full_cp       : coverpoint cov_seq_item.full;
            empty_cp      : coverpoint cov_seq_item.empty;
            almostfull_cp : coverpoint cov_seq_item.almostfull;
            almostempty_cp: coverpoint cov_seq_item.almostempty;
            underflow_cp  : coverpoint cov_seq_item.underflow;

            cross wr_en_cp, rd_en_cp, wr_ack_cp {
                ignore_bins wr_ack_without_wr =
                    binsof(wr_en_cp) intersect {0} && binsof(wr_ack_cp) intersect {1};
            }

            cross wr_en_cp, rd_en_cp, overflow_cp {
                ignore_bins overflow_without_wr =
                    binsof(wr_en_cp) intersect {0} && binsof(overflow_cp) intersect {1};
            }

            cross wr_en_cp, rd_en_cp, underflow_cp {
                ignore_bins underflow_without_rd =
                    binsof(rd_en_cp) intersect {0} && binsof(underflow_cp) intersect {1};
            }

            cross wr_en_cp, rd_en_cp, full_cp {
                ignore_bins rd_when_full =
                    binsof(rd_en_cp) intersect {1} && binsof(full_cp)  intersect {1};
            }

            cross wr_en_cp, rd_en_cp, empty_cp {
                ignore_bins wr_when_empty =
                    binsof(wr_en_cp) intersect {1} && binsof(empty_cp)  intersect {1};
            }

            cross wr_en_cp, rd_en_cp, almostfull_cp;
            cross wr_en_cp, rd_en_cp, almostempty_cp;
        endgroup

        function new (string name = "fifo_coverage", uvm_component parent = null);
            super.new(name, parent);
            cov_grp = new();
        endfunction
       
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(cov_seq_item);
                cov_grp.sample();
            end
        endtask
    endclass
endpackage