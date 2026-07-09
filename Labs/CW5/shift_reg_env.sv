package shift_reg_env_pkg;
import uvm_pkg::*;
import shift_reg_driver_pkg::*;
`include "uvm_macros.svh"

class shift_reg_env extends uvm_env;


  `uvm_component_utils(shift_reg_env)
  shift_reg_driver driver;

  function new(string name = "shift_reg_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = shift_reg_driver::type_id::create("driver", this);
  endfunction:build_phase
endclass
endpackage
