package alsu_main_sequence_pkg;
import alsu_sequence_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class alsu_main_sequence extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_main_sequence)
        alsu_seq_item seq_item;

        function new(string name = "alsu_main_sequence");
            super.new(name);
        endfunction

        task body();
        for(opcode_e op = OR; op < INVALID_6; op = op.next()) begin
            seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            assert(seq_item.randomize());
            seq_item.opcode = op;
            finish_item(seq_item);                            
        end
        repeat(10000) begin
            seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            assert(seq_item.randomize());
            finish_item(seq_item);
        end
        endtask
    endclass
endpackage