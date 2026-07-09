package shift_reg_test_pkg;
import shift_reg_env_pkg::*;
import shift_reg_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"


class shift_reg_test extends uvm_test;

  `uvm_component_utils(shift_reg_test)

  function new (string name = "shift_reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  shift_reg_env env;
  shift_reg_config shift_reg_cfg;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = shift_reg_env::type_id::create("env", this);

    shift_reg_cfg = shift_reg_config::type_id::create("shift_reg_cfg");
    if(!uvm_config_db#(virtual shift_reg_if)::get(this, "" ,"shift_reg_IF", shift_reg_cfg.shift_reg_vif))
      `uvm_fatal("build_phase", "Test - Unable to get Virtual Interface");
    uvm_config_db#(shift_reg_config)::set(this, "*", "CFG", shift_reg_cfg);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    #100; `uvm_info("run_phase", "Hi Welcome to Env.", UVM_NONE);
    phase.drop_objection(this);
  endtask: run_phase
endclass: shift_reg_test
endpackage