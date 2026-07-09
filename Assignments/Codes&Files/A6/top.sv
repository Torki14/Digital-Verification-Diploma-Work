import uvm_pkg::*;
`include "uvm_macros.svh"
import alsu_test_pkg::*;

module top();

    bit clk;
    initial begin
        clk = 0;
        forever 
        #1 clk = ~clk;
    end

    alsu_if alsuif(clk);
    
    ALSU DUT (  .clk        (alsuif.clk),
                .rst        (alsuif.rst),
                .cin        (alsuif.cin),
                .serial_in  (alsuif.serial_in),
                .red_op_A   (alsuif.red_op_A),
                .red_op_B   (alsuif.red_op_B),
                .opcode     (alsuif.opcode),
                .bypass_A   (alsuif.bypass_A),
                .bypass_B   (alsuif.bypass_B),
                .direction  (alsuif.direction),
                .A          (alsuif.A),
                .B          (alsuif.B),
                .leds       (alsuif.leds),
                .out        (alsuif.out)
            );

    bind ALSU alsu_sva binded_instance(
                .clk        (alsuif.clk),
                .rst        (alsuif.rst),
                .cin        (alsuif.cin),
                .serial_in  (alsuif.serial_in),
                .red_op_A   (alsuif.red_op_A),
                .red_op_B   (alsuif.red_op_B),
                .opcode     (alsuif.opcode),
                .bypass_A   (alsuif.bypass_A),
                .bypass_B   (alsuif.bypass_B),
                .direction  (alsuif.direction),
                .A          (alsuif.A),
                .B          (alsuif.B),
                .leds       (alsuif.leds),
                .out        (alsuif.out));

    initial begin
        uvm_config_db#(virtual alsu_if)::set(null, "uvm_test_top", "ALSU_IF", alsuif);
        run_test("alsu_test");
    end

endmodule