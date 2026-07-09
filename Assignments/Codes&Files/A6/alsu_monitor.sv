package alsu_monitor_pkg;
import alsu_config_pkg::*;
import alsu_sequence_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class alsu_monitor extends uvm_monitor;
        `uvm_component_utils(alsu_monitor)

        virtual alsu_if                       alsu_monitor_vif;
        alsu_seq_item                         rsp_seq_item;
        uvm_analysis_port #(alsu_seq_item)    mon_ap;

        function new(string name = "alsu_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                rsp_seq_item = alsu_seq_item::type_id::create("rsp_seq_item");
                @(negedge alsu_monitor_vif.clk);
                
                rsp_seq_item.cin       = alsu_monitor_vif.cin;
                rsp_seq_item.rst       = alsu_monitor_vif.rst;
                rsp_seq_item.red_op_A  = alsu_monitor_vif.red_op_A;
                rsp_seq_item.red_op_B  = alsu_monitor_vif.red_op_B;
                rsp_seq_item.bypass_A  = alsu_monitor_vif.bypass_A;
                rsp_seq_item.bypass_B  = alsu_monitor_vif.bypass_B;
                rsp_seq_item.direction = alsu_monitor_vif.direction;
                rsp_seq_item.serial_in = alsu_monitor_vif.serial_in;
                rsp_seq_item.opcode    = opcode_e'(alsu_monitor_vif.opcode);
                rsp_seq_item.A         = alsu_monitor_vif.A;
                rsp_seq_item.B         = alsu_monitor_vif.B;
                rsp_seq_item.out       = alsu_monitor_vif.out;
                rsp_seq_item.leds      = alsu_monitor_vif.leds;

                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
            end
        endtask
    endclass
endpackage
