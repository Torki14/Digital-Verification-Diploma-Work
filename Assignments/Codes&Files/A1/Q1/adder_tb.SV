module adder_tb;

// inputs to instantiated Adder
reg clk, reset;
reg signed [3:0] A; // Input data A: 2's complement
reg signed [3:0] B; // Input data B: 2's complement

// Output of Adder
wire signed [4:0] C; // Adder output: 2's complement

integer error_count;   // 32-bit signed
integer correct_count; // 32-bit signed

localparam MAXPOS = 7, ZERO = 0, MAXNEG = -8;

adder a1 (
    .clk(clk),
    .reset(reset),
    .A(A), // Input data A: signed
    .B(B), // Input data B: signed
    .C(C)  // Adder output: signed
);

// Create the clock and reset
initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end

initial begin
    error_count = 0;
    correct_count = 0;
    A = 0;
    B = 0;

    // ADDER_1
    assert_reset;

    // Apply all permutations of max pos, max neg, and 0

    // ADDER_2
    A = MAXNEG; B = MAXNEG;
    check_result(-16);

    // ADDER_3
    A = MAXNEG; B = ZERO;
    check_result(MAXNEG);

    // ADDER_4
    A = MAXNEG; B = MAXPOS;
    check_result(-1);

    // ADDER_5
    A = ZERO; B = MAXNEG;
    check_result(MAXNEG);

    // ADDER_6
    A = ZERO; B = ZERO;
    check_result(ZERO);

    // ADDER_7
    A = ZERO; B = MAXPOS;
    check_result(MAXPOS);

    // ADDER_8
    A = MAXPOS; B = MAXNEG;
    check_result(-1);

    // ADDER_9
    A = MAXPOS; B = ZERO;
    check_result(MAXPOS);

    // ADDER_10
    A = MAXPOS; B = MAXPOS;
    check_result(14);

    // ADDER_11
    A = MAXNEG; B = MAXPOS;
    check_result(-1);
    
    // ADDER_12
    assert_reset;


    $display("%t: At end of test error count is %0d and correct count = %0d",
             $time, error_count, correct_count);
    $stop;
end


task check_result (input signed [4:0] expected_result);
    @(negedge clk);
    if (expected_result !== C) begin
        error_count = error_count + 1;
        $display("%t: Error: For A= %0d, and B=%0d C should equal %0d but is %0d",
                 $time, A, B, expected_result, C);
    end
    else
        correct_count = correct_count + 1;
endtask


task assert_reset;
    // assert reset
    reset = 1;
    check_result(0);

    // desert reset
    reset = 0;
endtask

endmodule