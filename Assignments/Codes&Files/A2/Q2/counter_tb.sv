import counter_pkg::*;
module counter_tb;

bit clk, rst_n, load_n, up_down, ce;
logic [WIDTH - 1 : 0] data_load, count_out;
logic max_count, zero;

integer correct_count, error_count;

counter #(.WIDTH(WIDTH)) DUT(
    .clk(clk),
    .rst_n(rst_n), 
    .load_n(load_n), 
    .up_down(up_down), 
    .ce(ce), 
    .data_load(data_load), 
    .count_out(count_out), 
    .max_count(max_count), 
    .zero(zero)
);

initial begin
    clk = 0;
    forever
        #2 clk = ~clk;
end

logic max_count_exp, zero_exp;
logic [WIDTH - 1 : 0] count_out_exp;

task Golden_model;
    if(!rst_n) begin
        count_out_exp = 0;
        max_count_exp = 0;
        zero_exp = 1;
    end

    else begin
        if(load_n) begin
            if(ce) begin
                if(up_down)
                    count_out_exp = count_out_exp + 1 ;
                else
                    count_out_exp = count_out_exp - 1 ;    
            end
            else
                count_out_exp = count_out_exp;
        end
        else  
            count_out_exp = data_load;
    end

    max_count_exp = (count_out_exp == (2**WIDTH - 1));
    zero_exp      = (count_out_exp == 0);
    
endtask

counter_class Obj;

initial begin
correct_count = 0;
error_count = 0;    

data_load = 0;

count_out_exp = 0;
max_count_exp = 0;
zero_exp = 0;

//Counter_1
@(negedge clk);
assert_reset();
#10;
assert_reset();
Obj = new();

//Counter_2
for(int i = 0; i < 20; i++) begin
    assert(Obj.randomize());
    rst_n = Obj.rst_n;
    load_n = Obj.load_n; 
    up_down = Obj.up_down;
    ce = Obj.ce;
    data_load = Obj.data_load;
    @(posedge clk);
    Golden_model();
    check_result();
end

$display("%t: At end of test error count is %0d and correct count = %0d",
             $time, error_count, correct_count);
$stop;
end

task check_result;

    @(negedge clk);
    if(max_count_exp !=  max_count || zero_exp != zero || count_out_exp != count_out)
    begin
        error_count ++;
        $display("%t: Error: rst_n = %0d | load_n = %0d | up_down = %0d | ce = %0d | 
        data_load = %0d | count_out = %0d | zero = %0d | max_count = %0d | count_out_exp = %0d | 
        zero_exp = %0d | max_count_exp = %0d",$time, rst_n, load_n, up_down, 
        ce, data_load, count_out, zero, max_count, count_out_exp, zero_exp, max_count_exp);
    end
    else
        correct_count++;
endtask

task assert_reset;
    rst_n = 0;
    @(posedge clk);   
    Golden_model();
    check_result();

    rst_n = 1;
    @(posedge clk);   
    Golden_model();
    check_result();
endtask

endmodule