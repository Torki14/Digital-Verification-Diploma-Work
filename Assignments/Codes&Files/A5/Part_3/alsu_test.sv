package alsu_test_pkg;
import uvm_pkg::*;
import alsu_env_pkg::*;
import alsu_config_obj_pkg::*;
`include "uvm_macros.svh"
    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)

        alsu_env env;
        alsu_config_obj alsu_config_obj_test;
        
        function new (string name = "alsu_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase); 
            super.build_phase(phase);
            env = alsu_env::type_id::create("env", this);
            alsu_config_obj_test = alsu_config_obj::type_id::create("alsu_config_obj_test");
            if(!uvm_config_db#(virtual alsu_if)::get(this, "", "ALSU_IF", alsu_config_obj_test.alsu_config_vif))
                `uvm_fatal("build_phase", "Unable to get Virtual Interface from the Configuration Object");
            uvm_config_db#(alsu_config_obj)::set(this, "*", "CFG", alsu_config_obj_test);  
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            #100; `uvm_info("alsu_test", "Inside the ALSU Test.", UVM_NONE);
            phase.drop_objection(this);
        endtask
    endclass

endpackage