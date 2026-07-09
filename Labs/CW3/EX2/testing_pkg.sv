package testing_pkg;
typedef enum {ADD, SUB, MULT, DIV} opcode_e;
class Transaction;
    rand opcode_e opcode;
    rand byte operand1;
    rand byte operand2;
    bit clk;

    constraint c{
        opcode dist {ADD := 80, SUB := 80, [MULT:DIV] := 20};
        operand1 dist {-128 := 80, 127 := 80, 0 := 5, [1:126] := 5, [-127:-1] := 5};
    }

    covergroup CovCode @(posedge clk);
        opcode_cp: coverpoint opcode{
            bins ADDorSUB   = {ADD, SUB};
            bins ADDthenSUB = (ADD => SUB);
            illegal_bins noDIV = {DIV};
        }

        operand1_cp: coverpoint operand1{
            bins max_neg = {-128};
            bins zero = {0};
            bins max_pos = {127};
            bins others = default;
        }

        opcode_operand: cross opcode_cp, operand1_cp{
            option.weight = 5;
            option.cross_auto_bin_max = 0;
            bins ADDorUB_max_pos = binsof(opcode_cp.ADDorSUB) && binsof(operand1_cp.max_pos);
            bins ADDorUB_max_neg = binsof(opcode_cp.ADDorSUB) && binsof(operand1_cp.max_neg);
        }
    endgroup

    function new();
        CovCode = new();
    endfunction

endclass
endpackage