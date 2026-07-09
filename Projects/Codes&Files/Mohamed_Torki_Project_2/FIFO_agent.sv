package fifo_agent_pkg;
import fifo_sequence_item_pkg::*;
import fifo_sequencer_pkg::*;
import fifo_driver_package::*;
import fifo_monitor_pkg::*;
import fifo_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    
    class fifo_agent extends uvm_agent;
        `uvm_component_utils(fifo_agent)
        
        fifo_config fifo_agent_cfg;
        fifo_monitor mon;
        fifo_driver drv;
        fifo_sequencer sqr;

        uvm_analysis_port #(fifo_sequence_item) agent_ap;

        function new(string name = "fifo_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(fifo_config)::get(this, "", "CFG", fifo_agent_cfg))
                `uvm_fatal("build_phase", "Unable to get CFG for the Agent")

            mon = fifo_monitor::type_id::create("mon", this);   
            drv = fifo_driver::type_id::create("drv", this);
            sqr = fifo_sequencer::type_id::create("sqr", this);

            agent_ap = new("agent_ap", this);         
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.fifo_driver_vif = fifo_agent_cfg.fifo_config_vif;
            mon.fifo_monitor_vif = fifo_agent_cfg.fifo_config_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agent_ap);
        endfunction
    endclass 
endpackage