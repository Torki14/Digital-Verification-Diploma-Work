package shift_reg_seq_item_pkg;
import shift_reg_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class shift_reg_seq_item extends uvm_sequence_item;
        `uvm_object_utils(shift_reg_seq_item)

        rand bit reset, serial_in;
        rand mode_e mode;
        rand direction_e direction;
        rand logic [5:0] datain;
        logic [5:0] dataout;

        constraint rst_con{
            reset dist{0:= 5, 1:= 95};
        }

        function new(string name = "shift_reg_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s reset = %0d, serial_in = %0d, mode = %0s, direction = %0s, datain = %0d, dataout = %0d", super.convert2string(), reset, serial_in, mode, direction, datain, dataout);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = %0d, serial_in = %0d, mode = %0s, direction = %0s, datain = %0d", reset, serial_in, mode, direction, datain);
        endfunction
    endclass
endpackage