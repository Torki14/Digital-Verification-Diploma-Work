package class_pkg;

class Excercise2;
rand logic [7:0] data_in;
rand logic [3:0] address;

constraint c{data_in == 5;
            address dist{0:=10, [1:14]:/80, 15:=10};}

function void disp();
$display("data_in=0x%0h | address=0x%0h",data_in,address);
endfunction

function new(logic [7:0] data_in = 0, logic [3:0] address = 0);
    this.data_in = data_in;
    this.address = address;
endfunction

endclass

endpackage