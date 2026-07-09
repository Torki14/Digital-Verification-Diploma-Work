module Q2_1;
    bit clk;
    logic a, b;
    //method 1 
    sequence seq1
        a;
    endsequence

    sequence seq2
        ##2 b;
      //##1 b; 
    endsequence

    property p1;
        @(posedge clk) seq1 |-> seq2;
     // @(posedge clk) seq1 |=> seq2; 
    endproperty
    
    pr1 : assert property(p1);
    //method 2
    pr1_: assert property(@(posedge clk) a |-> ##2 b);
  //pr1_: assert property(@(posedge clk) a |=> ##1 b);

endmodule