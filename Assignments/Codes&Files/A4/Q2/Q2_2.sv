module Q2_2;
    bit clk;
    logic a, b, c;

    //method 1 
    sequence seq1
        a && b;
    endsequence

    sequence seq2
        ##[1:3] c;
      //##[0:2] c; 
    endsequence

    property p2;
        @(posedge clk) seq1 |-> seq2;
     // @(posedge clk) seq1 |=> seq2; 
    endproperty
    
    pr2 : assert property(p1);
    //method 2
    pr2_: assert property(@(posedge clk) a && b |-> ##[1:3] c;
  //pr2_: assert property(@(posedge clk) a && b |=> ##[0:2] c;

endmodule