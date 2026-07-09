package fifo_sequence_item_pkg;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class fifo_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(fifo_sequence_item)
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en; 
        logic      [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow, full, empty, almostfull, almostempty, underflow;
        
        constraint reset_con{
            rst_n dist{0 := 5, 1:= 95};
        }
        constraint write_con{
            wr_en dist{1 := 70, 0 := 100-70};
        }
        constraint read_con{
            rd_en dist{1 := 30, 0 := 100-30};
        }

        function new(string name = "fifo_sequence_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s data_in=%0h, data_out=%0h, rst_n=%0b, wr_en=%0b, rd_en=%0b, wr_ack=%0b, overflow=%0b, full=%0b, empty=%0b, almostfull=%0b, almostempty=%0b, underflow=%0b",
                            super.convert2string(),
                            data_in, data_out, rst_n, wr_en, rd_en,
                            wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("data_in=%0h, rst_n=%0b, wr_en=%0b, rd_en=%0b",
                            data_in, rst_n, wr_en, rd_en);
        endfunction
    endclass
endpackage