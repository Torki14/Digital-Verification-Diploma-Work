import counter_pkg::*;

module counter_tb;

bit clk, rst_n, load_n, up_down, ce;
bit [WIDTH-1:0] data_load;
logic max_count, max_count_exp, zero, zero_exp;
logic [WIDTH-1:0] count_out, count_out_exp;

counter_class Obj = new;

int error_count;
int correct_count;

counter #(.WIDTH(WIDTH)) DUT(
    .clk(clk),
    .rst_n(rst_n), 
    .load_n(load_n), 
    .up_down(up_down), 
    .ce(ce), 
    .data_load(data_load), 
    .count_out(count_out), 
    .max_count(max_count), 
    .zero(zero));

initial begin
    clk = 0;
    forever begin
    #1    clk = ~clk;
    Obj.clk = clk;
    end
end 

initial begin
    // COUNTER_6
    assert_reset;
    // COUNTER_7
    repeat (500) begin
        assert(Obj.randomize());
        rst_n     = Obj.rst_n;
        load_n    = Obj.load_n;
        up_down   = Obj.up_down;
        ce        = Obj.ce;
        data_load = Obj.data_load;

        check_result(Obj);
    end

    $display("%t: At end of test error count is %0d and correct count = %0d",
              $time, error_count, correct_count);
    $stop;
end

task check_result(input counter_class Obj_check);
    golden_model(Obj_check);

    if (Obj_check.rst_n !== 0) begin
        @(negedge clk);
        if ((max_count_exp !== max_count) || 
            (zero_exp !== zero) || 
            (count_out_exp !== count_out)) begin

            error_count = error_count + 1;

            $display("%t: Error: For rst_n=%0d, load_n=%0d, up_down=%0d, ce=%0d,
                     data_load=%0d, count_out=%0d",
                      $time, rst_n, load_n, up_down, ce, data_load, count_out);
        end
        else
            correct_count = correct_count + 1;
    end
    else begin 
        check_rst;
    end
endtask

// Golden Model
task golden_model(input counter_class Obj_golden);
    if (!Obj_golden.rst_n)
        count_out_exp = 0;
    else if (!Obj_golden.load_n)
        count_out_exp = Obj_golden.data_load;
    else if (Obj_golden.ce) begin
        if (Obj_golden.up_down)
            count_out_exp = count_out_exp + 1;
        else
            count_out_exp = count_out_exp - 1;
    end

    max_count_exp = (count_out_exp == {(WIDTH){1'b1}}) ? 1 : 0;
    zero_exp      = (count_out_exp == 0) ? 1 : 0;
endtask

task assert_reset;
    rst_n = 0;
    check_rst;

    rst_n = 1;
endtask

task check_rst;
    @(negedge clk);
    if (count_out !== 0 && max_count !== 0 && zero == 1) begin
        error_count = error_count + 1;
        $display("%t: Error: Reset value is asserted, outputs are with wrong reset values",
                  $time);
    end
    else
        correct_count = correct_count + 1;
endtask

endmodule