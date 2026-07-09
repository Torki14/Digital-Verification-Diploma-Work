module Q2_4_1;
    bit clk;
    logic [2:0] X;
    logic [7:0] Y;
    
    sequence seq
        $onehot(Y); //A Built-in function that returns true if only one bit was high
    endsequence

pr3: assert property (@(posedge clk) |-> seq);
   

endmodule