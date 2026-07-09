package fifo_write_only_sequence_pkg;
import fifo_sequence_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class fifo_write_only_sequence extends uvm_sequence #(fifo_sequence_item);
        `uvm_object_utils(fifo_write_only_sequence)
        fifo_sequence_item seq_item;

        function new(string name = "fifo_write_only_sequence");
            super.new(name);
        endfunction

        task body();
        repeat(10000) begin
            seq_item = fifo_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
            assert(seq_item.randomize() with {
                wr_en == 1'b1;
                rd_en == 1'b0;
            });
            finish_item(seq_item);
        end
        endtask

    endclass
endpackage