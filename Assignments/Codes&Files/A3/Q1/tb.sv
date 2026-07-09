import testing_pkg::*;
module tb;
    Transaction tr = new();
    byte operand1, operand2;
    bit clk, rst;
    opcode_e opcode;
    byte out;

    integer correct_count, error_count;
    byte expected;
    initial begin
        clk = 0;
        forever begin
        #1    clk = ~clk;
        tr.clk = clk;
        end
    end    
    alu_seq DUT(
        .clk(clk),
        .rst(rst),
        .operand1(operand1),
        .operand2(operand2),
        .out(out),
        .opcode(opcode)
    );

    initial begin
        correct_count = 0; 
        error_count = 0;
        //alu_seq3
        assert_reset();
        //alu_seq4
        repeat(32) begin
            assert(tr.randomize);
            operand1 = tr.operand1;
            operand2 = tr.operand2;
            opcode = tr.opcode;
            calc_expected(expected);
            check_result(expected);
        end
        assert_reset();
        $display("%t: At end of test error count is %0d and correct count = %0d",
             $time, error_count, correct_count);
        $stop();
    end

    task calc_expected(output byte expected);
        case (opcode)
            ADD:     expected = operand1 + operand2;
            SUB:     expected = operand1 - operand2;
            MULT:    expected = operand1 * operand2;
            DIV:     expected = operand1 / operand2;
            default: expected = 0;
        endcase
    endtask

    task check_result(input byte expected);
        @(negedge clk)
        if(expected != out)
        begin
            $display("At Time %t: opcode=%s | operand1=%0d | operand2=%0d | out=%0d | expected=%0d",
                    $time, opcode, operand1, operand2, out, expected);
            error_count++;
        end
        else
            correct_count++;
    endtask
    
    task assert_reset;
        rst = 1;
        @(negedge clk);
        check_result(0);
        rst = 0;
    endtask

endmodule