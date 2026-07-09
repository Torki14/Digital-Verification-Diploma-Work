////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_monitor(vending_machine_if.MONITOR v_if);
    // 1. Add the modport above
    //.MONITOR ADDED
    
    // 2. Add the monitor statement in an initial block
    initial 
        $monitor("rstn = %b, clk = %b, D_in = %b, Q_in = %b, dispense = %b, change = %b",v_if.rstn, v_if.clk, v_if.D_in, v_if.Q_in, v_if.dispense, v_if.change);
endmodule