package fifo_test_pkg;
import fifo_reset_sequence_pkg::*;
import fifo_read_only_sequence_pkg::*;
import fifo_write_only_sequence_pkg::*;
import fifo_write_read_sequence_pkg::*;
import fifo_config_pkg::*;
import fifo_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test)
        fifo_reset_sequence reset_seq;
        fifo_read_only_sequence rd_seq;
        fifo_write_only_sequence wr_seq;
        fifo_write_read_sequence wr_rd_seq;
        fifo_config fifo_test_cfg;
        fifo_env env; 

        function new(string name = "fifo_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            reset_seq = fifo_reset_sequence::type_id::create("reset_seq");
            rd_seq = fifo_read_only_sequence::type_id::create("rd_seq");
            wr_seq = fifo_write_only_sequence::type_id::create("wr_seq");
            wr_rd_seq = fifo_write_read_sequence::type_id::create("wr_rd_seq");
            env = fifo_env::type_id::create("env", this);
            fifo_test_cfg = fifo_config::type_id::create("fifo_test_cfg", this);
            if(!uvm_config_db#(virtual FIFO_if)::get(this, "", "fifo_IF", fifo_test_cfg.fifo_config_vif))
                `uvm_fatal("build_phase", "Unable to get Virtual Interface from the Configuration Object");

            uvm_config_db#(fifo_config)::set(this, "*", "CFG", fifo_test_cfg);  
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            //FIFO_1
            `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

            //FIFO_2
            `uvm_info("run_phase", "Write Stimulus Generation Started", UVM_LOW);
            wr_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Write Stimulus Generation Finished", UVM_LOW);

             //FIFO_3
           `uvm_info("run_phase", "Read Stimulus Generation Started", UVM_LOW);
            rd_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Read Stimulus Generation Finished", UVM_LOW);

            //FIFO_4
            `uvm_info("run_phase", "Read/Write Stimulus Generation Started", UVM_LOW);
            wr_rd_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Read/Write Stimulus Generation Finished", UVM_LOW);            

            phase.drop_objection(this);
        endtask
        
    endclass
endpackage