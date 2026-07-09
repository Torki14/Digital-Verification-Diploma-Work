module Q2_3;
    bit clk;
    logic b;

    sequence s11b
        repeat(2)@(posedge clk) b;  
    endsequence

endmodule