package pkg;
class MemTrans;
logic [7:0] data_in;
logic [3:0] address;

function void disp_mem();
$display("data_in=0x%0h | address=0x%0h",data_in,address);
endfunction

function new(logic [7:0] data_in = 0, logic [3:0] address = 0);
    this.data_in = data_in;
    this.address = address;
endfunction

endclass
endpackage