module adder_tb ();
bit clk, reset;
logic signed [3:0] A_tb, B_tb;
logic signed [4:0] C_tb;

parameter logic signed [3:0] MAXPOS = 7 ;
parameter logic signed [3:0] MAXNEG = -8;


initial begin
    clk = 0;
    forever #1 clk =~clk; 
end

int error_count = 0, correct_count  = 0;


adder ADD0(
    .A(A_tb),
    .B(B_tb),
    .C(C_tb),
    .clk(clk),
    .reset(reset)
);

task check_result (input logic signed [4:0] C_task);
    @(negedge clk)
    begin
        if(C_task != C_tb)begin
            $display("Wrong A = %0d| B = %0d| C = %0d| C_expected = %0d",A_tb, B_tb, C_tb, A_tb + B_tb);
            error_count++;
        end
        else
            correct_count++;
    end        
endtask

task assert_reset();
    reset = 1 ;
    check_result(0);
    reset = 0 ;
endtask

initial begin
    assert_reset();
    {A_tb,B_tb} = {4'b0,4'b0}; check_result(0);
    {A_tb,B_tb} = {4'b0,MAXPOS}; check_result(MAXPOS+0);
    {A_tb,B_tb} = {4'b0,MAXNEG}; check_result(0+MAXNEG);


    {A_tb,B_tb} = {MAXPOS,4'b0}; check_result(MAXPOS+0);
    {A_tb,B_tb} = {MAXPOS,MAXPOS}; check_result(MAXPOS+MAXPOS);
    {A_tb,B_tb} = {MAXPOS,MAXNEG}; check_result(MAXPOS+MAXNEG);


    {A_tb,B_tb} = {MAXNEG,4'b0}; check_result(MAXNEG+0);
    {A_tb,B_tb} = {MAXNEG,MAXPOS}; check_result(MAXNEG+MAXPOS);
    {A_tb,B_tb} = {MAXNEG,MAXNEG}; check_result(MAXNEG+MAXNEG);
    {A_tb,B_tb} = {4'b0, MAXNEG}; check_result(0+MAXNEG);
    assert_reset();

    $stop();
end



endmodule