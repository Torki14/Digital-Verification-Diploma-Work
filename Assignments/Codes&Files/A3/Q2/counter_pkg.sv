package counter_pkg;
parameter WIDTH = 4;

class counter_class;
    rand bit rst_n, load_n, up_down, ce;
    rand bit [WIDTH-1:0] data_load, count_out;
    parameter max_count = 2**WIDTH - 1;

    bit clk;

    // COUNTER_0
    constraint rst_constraint {
        rst_n dist {0 := 5, 1 := 95};
    }

    constraint load_constraint {
        load_n dist {0 := 70, 1 := 30};
    }

    constraint ce_constraint {
        ce dist {1 := 70, 0 := 30};
    }

    covergroup cover_counter @(posedge clk);
    
        // COUNTER_1
        cp1 : coverpoint data_load iff(!load_n && rst_n);
        // COUNTER_2
        cp2 : coverpoint count_out iff(rst_n && ce && up_down){
            bins count_out_bins_up[] = {[0 : max_count]}; 
        }
        // COUNTER_3
        cp3 : coverpoint count_out iff(rst_n && ce && up_down){
            bins overflow_bin = (max_count => 0);
        }
        // COUNTER_4
        cp4 : coverpoint count_out iff(rst_n && ce && !up_down){
            bins count_out_bins_down[] = {[0 : max_count]}; 
        }
        // COUNTER_5
        cp5 : coverpoint count_out iff(rst_n && ce && !up_down){
            bins underflow_bin = (0 => max_count);
        }
    endgroup

    function new();
        cover_counter = new();
    endfunction    

endclass
endpackage