import counter_pkg::*;

module counter_tb (counter_if.TEST c_if);

    counter_class Obj;

    initial begin
        c_if.rst_n = 1;
        c_if.load_n = 0;
        c_if.data_load = 0;
        c_if.up_down = 1;
        c_if.ce = 0;

        Obj = new();
        
        // COUNTER_6
        for(int i = 0; i < 1000; i++) begin
            @(negedge c_if.clk);
            assert(Obj.randomize());
            c_if.rst_n = Obj.rst_n;
            c_if.load_n = Obj.load_n; 
            c_if.up_down = Obj.up_down;
            c_if.ce = Obj.ce;
            c_if.data_load = Obj.data_load;
            
            @(posedge c_if.clk);
            Obj.count_out = c_if.count_out; 
            Obj.cover_counter.sample();
        end
        $stop;
    end

endmodule

