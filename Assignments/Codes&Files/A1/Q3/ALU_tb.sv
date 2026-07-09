module ALU_tb;

bit clk_tb, reset_tb;
logic [1:0] Opcode_tb;
logic signed [3:0] A_tb, B_tb;

logic signed [4:0] C_tb;

integer correct_count, error_count;
localparam [4:0] MAXPOS = 7, MAXNEG = -8 , ZERO = 0;


ALU DUT0(
    .clk(clk_tb),
    .reset(reset_tb),
    .Opcode(Opcode_tb),
    .A(A_tb),
    .B(B_tb),

    .C(C_tb)
);

initial begin
    clk_tb = 0;
    forever
        #1 clk_tb = ~clk_tb;
end

initial begin
correct_count = 0;
error_count = 0;
reset_tb = 0;
Opcode_tb = 0;
A_tb = 0; 
B_tb = 0;

//ALU_0
assert_reset();
@(negedge clk_tb);
assert_reset();

//ALU_1  
Opcode_tb =2'b00;
A_tb = MAXPOS; B_tb = MAXPOS;
check_result(14);

A_tb = MAXPOS; B_tb = MAXNEG;
check_result(-1);

A_tb = MAXPOS; B_tb = ZERO;
check_result(MAXPOS);

A_tb = MAXNEG; B_tb = MAXPOS;
check_result(-1);

A_tb = ZERO; B_tb = MAXPOS;
check_result(MAXPOS);

A_tb = ZERO; B_tb = MAXNEG;
check_result(MAXNEG);

A_tb = ZERO; B_tb = ZERO;
check_result(0);

A_tb = MAXNEG; B_tb = MAXNEG;
check_result(-16);

A_tb = MAXNEG; B_tb = ZERO;
check_result(MAXNEG);

//ALU_2  
Opcode_tb =2'b01;
A_tb = MAXPOS; B_tb = MAXPOS;
check_result(ZERO);

A_tb = MAXPOS; B_tb = MAXNEG;
check_result(15);

A_tb = ZERO; B_tb = MAXPOS;
check_result(-7);

A_tb = ZERO; B_tb = MAXNEG;
check_result(8);

A_tb = MAXNEG; B_tb = MAXPOS;
check_result(-15);

A_tb = MAXPOS; B_tb = ZERO;
check_result(MAXPOS);

A_tb = MAXNEG; B_tb = MAXNEG;
check_result(ZERO);

A_tb = ZERO; B_tb = ZERO;
check_result(0);

A_tb = MAXNEG; B_tb = ZERO;
check_result(MAXNEG);


//ALU_3  
Opcode_tb =2'b10;
A_tb = 4'b0000;

repeat (17) begin
    check_result($signed(~A_tb));
    A_tb++;
end

//ALU_4
Opcode_tb =2'b11;
B_tb = 4'b0000;

repeat (17) begin
    if(B_tb == 4'b0000)
        check_result(0);
    else
        check_result(1);    
    B_tb++; 
end

//ALU_5
A_tb = 4'b0111; B_tb = 4'b1110;
Opcode_tb = 2'b00;

repeat (5) begin
    if(Opcode_tb == 2'b00)
        check_result(A_tb + B_tb);

    else if(Opcode_tb == 2'b01)
        check_result(A_tb - B_tb);  

    else if(Opcode_tb == 2'b10)
        check_result(5'b11000);

    else if(Opcode_tb == 2'b11)
        check_result(1);       
    Opcode_tb++; 
end

Opcode_tb = 2'bxx;
check_result(0);

$display("%t: At end of test error count is %0d and correct count = %0d",
             $time, error_count, correct_count);
    $stop;
end

task check_result (input signed [4:0] expected_result);
    @(negedge clk_tb);
    if ($signed(expected_result) !== C_tb) begin
        error_count = error_count + 1;
        $display("%t: Error: For A_tb = %0d | B_tb = %0d | Opcode_tb = %0d | 
                 C_tb should equal %0d but is %0d",
                 $time, A_tb, B_tb,Opcode_tb,expected_result, C_tb);
    end
    else
        correct_count = correct_count + 1;
endtask

task assert_reset;
    reset_tb = 1;
    check_result(0);
    reset_tb = 0;
endtask

endmodule