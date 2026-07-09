import ALSU_pkg ::*;
module ALSU_tb;

bit clk, rst;
logic cin, serial_in, direction, red_op_A, red_op_B, bypass_A, bypass_B;
logic signed [2:0] A, B;
logic [2:0] opcode;

logic [15:0] leds;
logic signed [5:0] out;

logic [15:0] leds_exp;
logic signed [5:0] out_exp;

localparam FULL_ADDER = "ON";
localparam INPUT_PRIORITY = "A";

integer correct_count, error_count;


initial begin
    clk = 0;
    forever
        #2 clk = ~clk;
end

ALSU #(.FULL_ADDER(FULL_ADDER), .INPUT_PRIORITY(INPUT_PRIORITY)) DUT(.*);

ALSU_GM #(.FULL_ADDER(FULL_ADDER), .INPUT_PRIORITY(INPUT_PRIORITY)) Golden_Model(
    .clk(clk),
    .rst(rst),
    .cin(cin),
    .serial_in(serial_in),
    .direction(direction),
    .red_op_A(red_op_A),
    .red_op_B(red_op_B),
    .bypass_A(bypass_A),
    .bypass_B(bypass_B),
    .A(A),
    .B(B),
    .opcode(opcode),

    .out(out_exp),
    .leds(leds_exp)
);

ALSU_class Obj; 

initial begin   

correct_count = 0;
error_count = 0;    

//ALSU_7
@(negedge clk);
assert_reset();
assert_reset();

Obj = new();

//ALSU_8
for(int i = 0; i < 300; i++) begin
    assert(Obj.randomize());
    opcode = Obj.opcode;
    A = Obj.A;
    B = Obj.B;
    rst =  Obj.rst;
    cin = Obj.cin;
    serial_in = Obj.serial_in;
    direction = Obj.direction;
    red_op_A = Obj.red_op_A;
    red_op_B = Obj.red_op_B;
    bypass_A = Obj.bypass_A;
    bypass_B =Obj.bypass_B;

    check_result();
end

$display("%t: At end of test error count is %0d and correct count = %0d",
             $time, error_count, correct_count);
$stop;
end

task check_result;
    @(negedge clk);
    if(leds != leds_exp  || out != out_exp)
    begin
        error_count ++;
        $display("%t: Error: OPCODE = %0d | leds = %0d | out = %0d | leds_exp = %0d | 
                    out_exp = %0d", $time,opcode, leds, out, leds_exp, out_exp);
    end
    else
        correct_count++;
endtask

task assert_reset;
    rst = 1;
    check_result();
    rst = 0;
    check_result();
endtask

endmodule