package counter_pkg;

parameter WIDTH = 4;
    class counter_class;
    rand bit up_down;
    rand logic [WIDTH - 1 : 0] data_load ;
    rand logic rst_n, load_n, ce; 

    constraint c{
        rst_n dist{0:=10, 1:=90};
        load_n dist{0:=30, 1:=70};
        ce dist{0:=30, 1:=70};
        data_load inside {[0 : (2**WIDTH - 1)]};
    }

    function new();
    this.up_down = 1;
    this.rst_n = 1;
    this.load_n = 1;
    this.ce = 1;
    this.data_load = 0;
    endfunction

    endclass
endpackage;