package fifo_monitor_pkg;
import fifo_sequence_item_pkg::*;
import fifo_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class fifo_monitor extends uvm_monitor;
        `uvm_component_utils(fifo_monitor)
        virtual FIFO_if fifo_monitor_vif;
        fifo_sequence_item rsp_seq_item;
        uvm_analysis_port #(fifo_sequence_item) mon_ap;

        function new(string name = "fifo_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = fifo_sequence_item::type_id::create("rsp_seq_item");

                @(negedge fifo_monitor_vif.clk);
                rsp_seq_item.data_in = fifo_monitor_vif.data_in;
                rsp_seq_item.rst_n = fifo_monitor_vif.rst_n;
                rsp_seq_item.wr_en = fifo_monitor_vif.wr_en;
                rsp_seq_item.rd_en = fifo_monitor_vif.rd_en;
                rsp_seq_item.data_out = fifo_monitor_vif.data_out;
                rsp_seq_item.wr_ack = fifo_monitor_vif.wr_ack;
                rsp_seq_item.overflow = fifo_monitor_vif.overflow;
                rsp_seq_item.full = fifo_monitor_vif.full;
                rsp_seq_item.empty = fifo_monitor_vif.empty;
                rsp_seq_item.almostfull = fifo_monitor_vif.almostfull;
                rsp_seq_item.almostempty = fifo_monitor_vif.almostempty;
                rsp_seq_item.underflow = fifo_monitor_vif.underflow;

                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
            end
        endtask

    endclass
endpackage