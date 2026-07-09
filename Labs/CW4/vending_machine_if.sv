////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
interface vending_machine_if(clk);
    // 1. Add the parameters (WAIT = 0, Q_25 = 1, Q_50 =2)
    parameter WAIT = 2'b00;
    parameter Q_25 = 2'b01;
    parameter Q_50 = 2'b10;

    // 2. Add the clock as an input port
    input bit clk;

    // 3. Add the internal signals of the interface
    logic D_in, Q_in, dispense, change, rstn;

    // 4. Add the modports
    modport DUT(input D_in, Q_in, clk, rstn,
                    output dispense, change);

    modport TEST(output D_in, Q_in, rstn,
                    input dispense, change, clk);

    modport MONITOR(input D_in, Q_in, dispense, change, clk, rstn);    

endinterface 