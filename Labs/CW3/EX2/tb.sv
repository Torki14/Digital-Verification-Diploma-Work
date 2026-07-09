import testing_pkg::*;

module tb;

    Transaction tr = new();
    byte operand1, operand2;
    bit clk, rst;
    opcode_e opcode;
    byte out;

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
        rst = 1;
        @(negedge clk);
        rst = 0;
        repeat(32) begin
            assert(tr.randomize);
            operand1 = tr.operand1;
            operand2 = tr.operand2;
            opcode = tr.opcode;
            @(negedge clk);
        end
        $stop();
    end
endmodule