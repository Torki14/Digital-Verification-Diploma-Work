module counter_top ();

    bit clk;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    counter_if c_if (clk);

    counter DUT (c_if);
    counter_tb TEST(c_if);

    bind counter counter_sva counter_binded_inst(c_if);
endmodule