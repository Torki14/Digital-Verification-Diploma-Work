package fifo_reset_sequence_pkg;
import fifo_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class fifo_reset_sequence extends uvm_sequence #(fifo_sequence_item);
        `uvm_object_utils(fifo_reset_sequence)
        fifo_sequence_item seq_item;

        function new(string name = "fifo_reset_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = fifo_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 1'b0;
            finish_item(seq_item);
        endtask

    endclass
endpackage