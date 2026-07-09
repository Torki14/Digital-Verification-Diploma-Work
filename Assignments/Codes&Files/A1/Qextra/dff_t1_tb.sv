module dff_t1_tb;
bit clk_tb, rst_tb, en_tb;
logic d_tb ;
logic q_tb;

localparam USE_EN_tb = 1;

integer correct_count, error_count;

initial begin
    clk_tb = 0;
    forever 
        #2 clk_tb = ~clk_tb;
end

//reference model
logic q_expected;
always@(posedge clk_tb)begin
    if(rst_tb)
        q_expected = 0;
    else if(en_tb)
        q_expected = d_tb;
    else
        q_expected = q_expected;
end

dff #(.USE_EN(USE_EN_tb)) DUT0(
    .clk(clk_tb),
    .rst(rst_tb),
    .en(en_tb),
    .d(d_tb),
    .q(q_tb)
);

initial begin
    rst_tb = 0;
    en_tb = 0;
    d_tb = 0;
    error_count = 0; 
    correct_count = 0;

    //dff_0
    assert_reset();
    repeat(2)@(negedge clk_tb)
    #3;
    assert_reset();

    //dff_1
    for(int i = 0; i < 15; i++) begin
        {en_tb,d_tb}++;
        check_result();
    end
        
    $display("%t: At end of test error count is %0d and correct count = %0d",
                $time, error_count, correct_count);
    $stop;    
end

task check_result;
    @(negedge clk_tb);
    if(q_expected != q_tb) begin
        error_count ++;
        $display("%t: Error: For d_tb = %0d | en_tb = %0d | q_tb should equal %0d but is %0d",
                 $time, d_tb, en_tb,q_expected,q_tb);
    end
    else
        correct_count++;
endtask

task assert_reset;
rst_tb = 1;
check_result();
rst_tb = 0;
endtask


endmodule