module priority_enc_tb ;

bit clk_tb, rst_tb;
logic [3:0] D_tb;
logic [1:0] Y_tb;
logic valid_tb;

logic valid_ref;
logic [1:0] Y_ref;

integer correct_count, error_count;

priority_enc DUT0(
    .clk(clk_tb),
    .rst(rst_tb),
    .D(D_tb),
    .Y(Y_tb),
    .valid(valid_tb)
);

initial begin
    clk_tb = 0;
    forever
        #1 clk_tb = ~clk_tb;
end

initial begin
correct_count = 0;
error_count = 0;
rst_tb = 0;
D_tb = 0;

//priority_enc 0
assert_reset();
@(negedge clk_tb);
assert_reset();

//priority_enc 1
repeat (17) begin
    D_tb++;
    @(negedge clk_tb);
    {valid_ref, Y_ref} = expected_result(rst_tb,D_tb);
    check_result(valid_ref, Y_ref);
end

$display("%t: At end of test error count is %0d and correct count = %0d",
             $time, error_count, correct_count);
    $stop;
end

task check_result(input logic valid_expected, input logic [2:0] Y_expected);
    @(negedge clk_tb)
    if(Y_expected != Y_tb | valid_expected != valid_tb)
    begin
        $display("At Time %t: D_tb = %0d | rst_tb = %0d | Y_tb = %0d | 
                Y_expected = %0d | Valid_tb = %0d | Valid_expected = %0d", 
                $time,D_tb,rst_tb,Y_tb,Y_expected,valid_tb,valid_expected);
        error_count++;
    end
    else
        correct_count++;
endtask

task assert_reset;
    rst_tb = 1;
    check_result(0,0);
    rst_tb = 0;
endtask

function logic [2:0] expected_result (input logic rst_fn, input logic [3:0] D_fn);
    if (rst_fn)
        expected_result = {1'b0, 2'b00};
        
    else if (D_fn[0])
        expected_result = {1'b1, 2'b11};
        
    else if (D_fn[1])
        expected_result = {1'b1, 2'b10};
        
    else if (D_fn[2])
        expected_result = {1'b1, 2'b01};
        
    else if (D_fn[3])
        expected_result = {1'b1, 2'b00};
        
    else
        expected_result = {1'b0, 2'bxx};
endfunction

endmodule