package alsu_test_pkg;
import uvm_pkg::*;
import alsu_env_pkg::*;
import alsu_main_sequence_pkg::*;
import alsu_reset_sequence_pkg::*;
import alsu_config_pkg::*;
`include "uvm_macros.svh"
    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)

        alsu_env env;
        alsu_config alsu_config_test;
        alsu_reset_sequence reset_seq;
        alsu_main_sequence main_seq;
        
        function new (string name = "alsu_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase); 
            super.build_phase(phase);
            env = alsu_env::type_id::create("env", this);
            reset_seq = alsu_reset_sequence::type_id::create("reset_seq");
            main_seq = alsu_main_sequence::type_id::create("main_seq");
            alsu_config_test = alsu_config::type_id::create("alsu_config_test");
            if(!uvm_config_db#(virtual alsu_if)::get(this, "", "ALSU_IF", alsu_config_test.alsu_config_vif))
                `uvm_fatal("build_phase", "Unable to get Virtual Interface from the Configuration Object");

            uvm_config_db#(alsu_config)::set(this, "*", "CFG", alsu_config_test);  
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

            `uvm_info("run_phase", "Stimulus Generation Started", UVM_LOW);
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Stimulus Generation Finished", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass

endpackage