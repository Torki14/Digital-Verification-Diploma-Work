module counter_sva (counter_if.DUT c_if);
    
    // COUNTER_7
    property p1;
        @(posedge c_if.clk) 
        disable iff(!c_if.rst_n)
        ~(c_if.load_n) |=> (c_if.count_out == $past(c_if.data_load)); 
    endproperty

    // COUNTER_8
    property p2;
        @(posedge c_if.clk) 
        disable iff(!c_if.rst_n)
        (c_if.load_n && ~c_if.ce) |=> $stable(c_if.count_out);
    endproperty

    // COUNTER_9
    property p3;
        @(posedge c_if.clk) 
        disable iff(!c_if.rst_n)
        (c_if.load_n && c_if.ce && c_if.up_down) |=> ($past(c_if.count_out) == c_if.count_out - 1'b1);
    endproperty

    // COUNTER_10
    property p4;
        @(posedge c_if.clk) 
        disable iff(!c_if.rst_n)
        (c_if.load_n && c_if.ce && ~c_if.up_down) |=> ($past(c_if.count_out) == c_if.count_out + 1'b1);
    endproperty

    // COUNTER_11
    always_comb begin
        if(!c_if.rst_n)
            p5: assert final(c_if.count_out == 1'b0);
    end

    // COUNTER_12
    property p6;
        @(posedge c_if.clk) 
        (c_if.count_out == c_if.MAX) |-> c_if.max_count;
    endproperty

    // COUNTER_13
    property p7;
        @(posedge c_if.clk) 
        (c_if.count_out == 1'b0) |-> c_if.zero;
    endproperty

    p1_a: assert property (p1);
    p1_c: cover  property (p1);

    p2_a: assert property (p2);
    p2_c: cover  property (p2);

    p3_a: assert property (p3);
    p3_c: cover  property (p3);

    p4_a: assert property (p4);
    p4_c: cover  property (p4);

    p6_a: assert property (p6);
    p6_c: cover  property (p6);

    p7_a: assert property (p7);
    p7_c: cover  property (p7);

endmodule