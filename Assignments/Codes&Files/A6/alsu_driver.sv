package alsu_driver_pkg;
import alsu_config_pkg::*;
import alsu_sequence_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class alsu_driver extends uvm_driver #(alsu_seq_item);
        `uvm_component_utils(alsu_driver)

        virtual alsu_if alsu_driver_vif;
        alsu_seq_item   stim_seq_item;

        function new(string name = "alsu_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item_port.get_next_item(stim_seq_item);

                alsu_driver_vif.cin       = stim_seq_item.cin;
                alsu_driver_vif.rst       = stim_seq_item.rst;
                alsu_driver_vif.red_op_A  = stim_seq_item.red_op_A;
                alsu_driver_vif.red_op_B  = stim_seq_item.red_op_B;
                alsu_driver_vif.bypass_A  = stim_seq_item.bypass_A;
                alsu_driver_vif.bypass_B  = stim_seq_item.bypass_B;
                alsu_driver_vif.direction = stim_seq_item.direction;
                alsu_driver_vif.serial_in = stim_seq_item.serial_in;
                alsu_driver_vif.opcode    = stim_seq_item.opcode;
                alsu_driver_vif.A         = stim_seq_item.A;
                alsu_driver_vif.B         = stim_seq_item.B;

                @(negedge alsu_driver_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass

endpackage
