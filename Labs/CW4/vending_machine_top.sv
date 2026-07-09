////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_top();
    // 1. Generate the clock
    bit clk;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // 2. instantiate the interface, and pass the clock
    vending_machine_if v_if(clk);

    // 3. instantiate the tb, DUT, monitor, and pass the interface
    vending_machine DUT (v_if);
    vending_machine_tb TEST (v_if);
    vending_machine_monitor MONITOR (v_if);

    // 4. bind the SVA module to the design, and pass the interface
    bind vending_machine vending_machine_sva vending_machine_inst(v_if);

endmodule
