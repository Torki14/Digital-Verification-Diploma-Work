module Q2_4_2;
    bit clk;
    logic [3:0] D;
    logic [1:0] Y;
    logic valid;

   //method 1 
    sequence seq1
        D == 0;
    endsequence

    sequence seq2
        ##1 valid == 0;
          //valid == 0; 
    endsequence

    property p4;
        @(posedge clk) seq1 |-> seq2;
     // @(posedge clk) seq1 |=> seq2; 
    endproperty
    
    pr4 : assert property(p4);
    //method 2
    pr4_: assert property(@(posedge clk) (D == 0) |-> ##1 (valid == 0);
  //pr2_: assert property(@(posedge clk) (D == 0) |=> (valid == 0);
   
endmodule