module DSP_tb();
bit clk_tb, rst_n_tb;
logic [17:0] A_tb, B_tb, D_tb;
logic [47:0] C_tb;
logic [47:0] P_tb;

localparam OPERATION_tb = "ADD";
integer correct_count, error_count;
localparam MAXPOS_1 = 18'h3ffff,MAXPOS_2 = 48'hffffffffffff, ZERO = 18'h0000;

DSP #(.OPERATION(OPERATION_tb)) DUT0(
    .A(A_tb),
    .B(B_tb),
    .C(C_tb),
    .D(D_tb),
    .clk(clk_tb),
    .rst_n(rst_n_tb),
    .P(P_tb)
);

initial begin
    clk_tb = 0;
    forever
        #2 clk_tb = ~clk_tb;
end


//reference model 
logic [17:0] adder_out_stg1_expected;
logic [47:0] mult_out_expected;
logic [47:0] P_expected;
always@(*) begin
if(!rst_n_tb)
    P_expected = 0;
    else begin  
    adder_out_stg1_expected =  D_tb + B_tb ;
    mult_out_expected = A_tb * adder_out_stg1_expected;
    P_expected = C_tb + mult_out_expected;
    end
end

initial begin 
    A_tb = 0; 
    B_tb = 0; 
    C_tb = 0; 
    D_tb = 0; 
    rst_n_tb = 1; 
    correct_count = 0; 
    error_count = 0;
    repeat(5)@(negedge clk_tb);

    //DSP_0
    assert_reset();
    A_tb = $random; 
    B_tb = $random; 
    C_tb = $random; 
    D_tb = $random;
    repeat(5)@(negedge clk_tb);
    #3; //Checking Asynchronous property
    assert_reset();    

    //DSP_1
    repeat(3)@(negedge clk_tb);
    A_tb = MAXPOS_1; 
    B_tb = MAXPOS_1; 
    C_tb = MAXPOS_2; 
    D_tb = MAXPOS_1;
    check_result();

    A_tb = ZERO; 
    B_tb = ZERO; 
    C_tb = ZERO; 
    D_tb = ZERO;
    check_result();

    for(int i = 0; i < 51; i++)begin
        A_tb = $random; 
        B_tb = $random; 
        C_tb = $random; 
        D_tb = $random;
        check_result();
    end

    $display("%t: At end of test error count is %0d and correct count = %0d",
             $time, error_count, correct_count);
    $stop;
end

task check_result;
    repeat(5)@(negedge clk_tb);
    if(P_expected != P_tb)
    begin
        error_count ++;
        $display("%t: Error: For A_tb = %0d | B_tb = %0d | C_tb = %0d | D_tb = %0d | 
                 P_tb should equal %0d but is %0d",
                 $time, A_tb, B_tb,C_tb,D_tb,P_expected, P_tb);
    end
    else
        correct_count++;
endtask

task assert_reset;
    rst_n_tb = 0;
    check_result();
    rst_n_tb = 1;
endtask
endmodule