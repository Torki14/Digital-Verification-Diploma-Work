interface counter_if (clk);

    parameter WIDTH = 4;
    parameter MAX = 2**WIDTH - 1;

    input bit clk;

    bit rst_n, load_n, up_down, ce;
    bit [WIDTH-1:0] data_load;
    logic max_count, zero;
    logic [WIDTH-1:0] count_out;


    modport DUT  (input rst_n, load_n, up_down, ce, data_load, clk, 
                output max_count, zero, count_out);

    modport TEST (input max_count, zero, count_out, clk,
                 output rst_n, load_n, up_down, ce, data_load);           

endinterface