package fifo_driver_package;
import fifo_config_pkg::*;
import fifo_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class fifo_driver extends uvm_driver #(fifo_sequence_item);
        `uvm_component_utils(fifo_driver)
        virtual FIFO_if fifo_driver_vif;
        fifo_sequence_item stim_seq_item;

        function new(string name = "fifo_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item_port.get_next_item(stim_seq_item);

                fifo_driver_vif.data_in = stim_seq_item.data_in;
                fifo_driver_vif.rst_n = stim_seq_item.rst_n;
                fifo_driver_vif.wr_en = stim_seq_item.wr_en;
                fifo_driver_vif.rd_en = stim_seq_item.rd_en;

                @(negedge fifo_driver_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
    
endpackage