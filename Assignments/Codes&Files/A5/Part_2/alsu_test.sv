package alsu_test_pkg;
import uvm_pkg::*;
import alsu_env_pkg::*;
`include "uvm_macros.svh"
    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)

        alsu_env env;
        virtual alsu_if alsu_test_vif;

        function new (string name = "alsu_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase); 
            super.build_phase(phase);
            if(!uvm_config_db#(virtual alsu_if)::get(this, "", "ALSU_IF", alsu_test_vif))
                `uvm_fatal("build_phase", "Unable to get Virtual Interface");
            uvm_config_db#(virtual alsu_if)::set(this, "*", "ALSU_IF", alsu_test_vif);  
            env = alsu_env::type_id::create("env", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            #100; `uvm_info("alsu_test", "Inside the ALSU Test.", UVM_NONE);
            phase.drop_objection(this);
        endtask
    endclass

endpackage