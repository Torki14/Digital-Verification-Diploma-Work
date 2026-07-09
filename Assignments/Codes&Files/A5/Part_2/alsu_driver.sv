package alsu_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class alsu_driver extends uvm_driver;

        virtual alsu_if alsu_driver_vif;

        `uvm_component_utils(alsu_driver)

        function new(string name = "alsu_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(virtual alsu_if)::get(this, "", "ALSU_IF", alsu_driver_vif))
                `uvm_fatal("build_phase","Unable to get Virtual Interface to the driver");
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            alsu_driver_vif.rst = 1;
            alsu_driver_vif.A = 0;
            alsu_driver_vif.B = 0;
            alsu_driver_vif.cin = 0;
            alsu_driver_vif.red_op_A = 0;
            alsu_driver_vif.red_op_B = 0;
            alsu_driver_vif.bypass_A = 0;
            alsu_driver_vif.bypass_B = 0;
            alsu_driver_vif.direction = 0;
            alsu_driver_vif.serial_in = 0;
            alsu_driver_vif.opcode = 0;

            @(negedge alsu_driver_vif.clk);
            alsu_driver_vif.rst = 0;
            forever begin
                @(negedge alsu_driver_vif.clk);
                alsu_driver_vif.A = $random;
                alsu_driver_vif.B = $random;
                alsu_driver_vif.cin = $random;
                alsu_driver_vif.red_op_A = $random;
                alsu_driver_vif.red_op_B = $random;
                alsu_driver_vif.bypass_A = $random;
                alsu_driver_vif.bypass_B = $random;
                alsu_driver_vif.direction = $random;
                alsu_driver_vif.serial_in = $random;
                alsu_driver_vif.opcode = $random;
                alsu_driver_vif.rst = $random;
            end
        endtask
    endclass

endpackage