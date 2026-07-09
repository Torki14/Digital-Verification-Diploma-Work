////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_sva(vending_machine_if.DUT v_if);
// 1. Add the modport above

// 2. Add the following 3 properties, then use assert property and cover property on each property
//// First Assertion: At each positive edge of the clock, if the D_in is high then at the same clock cycle, the dispense and the change outputs are high
    property p_dollar;
        @(posedge v_if.clk ) v_if.D_in |-> (v_if.dispense && v_if.change);
    endproperty
//// Second Assertion: At each positive edge of the clock, If there is a rising edge for the input Q_in then after 2 clock cycles the dispense output is high
    property p_quarter_dispense;
        @(posedge v_if.clk) $rose(v_if.Q_in) |-> ##2 v_if.dispense;
    endproperty
//// Third Assertion: At each positive edge of the clock, if the Q_in is high then at the same clock cycle, the change must be low
    property p_quarter_low_change;
        @(posedge v_if.clk) v_if.Q_in |-> !(v_if.change) ;
    endproperty

    aP1: assert property(p_dollar) else $display("Assertion 1 Fail");
    cP1: cover  property(p_dollar) $display("Assertion 1 Pass");

    aP2: assert property(p_quarter_dispense) else $display("Assertion 2 Fail");
    cP2: cover  property(p_quarter_dispense) $display("Assertion 2 Pass");

    aP3: assert property(p_quarter_low_change) else $display("Assertion 3 Fail");
    cP3: cover  property(p_quarter_low_change) $display("Assertion 3 Pass");

endmodule