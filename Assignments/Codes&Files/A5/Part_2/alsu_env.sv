package alsu_env_pkg;
import uvm_pkg::*;
import alsu_driver_pkg::*;
`include "uvm_macros.svh"

alsu_driver driver;

class alsu_env extends uvm_env;
    `uvm_component_utils(alsu_env)
    function new(string name = "alsu_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = alsu_driver::type_id::create("driver", this);
    endfunction:build_phase
endclass
endpackage