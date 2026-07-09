module alsu_sva (input  logic clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in,
                 input  logic [2:0]  opcode,
                 input  logic signed [2:0] A, B,
                 input  logic [15:0] leds,
                 input  logic signed [5:0] out
                );
import shared_pkg::*;
    
    property INVALID_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == INVALID_6 || opcode == INVALID_7) || (opcode[1] && opcode[2]) |-> ##2 (out == 6'b0 && leds == ~$past(leds, 1));
    endproperty


    property OR_A_PRIORITY_A_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == OR && red_op_A == 1'b1 && INPUT_PRIORITY == "A") |-> ##2 (out == |$past(A, 2));
    endproperty

    property OR_A_PRIORITY_B_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == OR && red_op_A == 1'b1 && INPUT_PRIORITY == "B" && red_op_B == 1'b0) |-> ##2 (out == |$past(A, 2));
    endproperty

    property OR_B_PRIORITY_B_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == OR && red_op_B == 1'b1 && INPUT_PRIORITY == "B") |-> ##2 (out == |$past(B, 2));
    endproperty

    property OR_B_PRIORITY_A_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == OR && red_op_B == 1'b1 && INPUT_PRIORITY == "A" && red_op_A == 1'b0) |-> ##2 (out == |$past(B, 2));
    endproperty

    property XOR_A_PRIORITY_A_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == XOR && red_op_A == 1'b1 && INPUT_PRIORITY == "A") |-> ##2 (out == ^$past(A, 2));
    endproperty

    property XOR_A_PRIORITY_B_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == XOR && red_op_A == 1'b1 && INPUT_PRIORITY == "B" && red_op_B == 1'b0) |-> ##2 (out == ^$past(A, 2));
    endproperty

    property XOR_B_PRIORITY_B_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == XOR && red_op_B == 1'b1 && INPUT_PRIORITY == "B") |-> ##2 (out == ^$past(B, 2));
    endproperty

    property XOR_B_PRIORITY_A_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B) 
        (opcode == XOR && red_op_B == 1'b1 && INPUT_PRIORITY == "A" && red_op_A == 1'b0) |-> ##2 (out == ^$past(B, 2));
    endproperty

    property FULL_ADD_ON_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B || red_op_A || red_op_B || !(opcode == ADD && FULL_ADDER == "ON")) 
        (opcode == ADD && FULL_ADDER == "ON") |-> ##2 (out == $past(A, 2) + $past(B, 2) + $past(cin, 2));
    endproperty

    property FULL_ADD_OFF_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B || red_op_A || red_op_B || !(opcode == ADD && FULL_ADDER == "OFF")) 
        (opcode == ADD && FULL_ADDER == "OFF") |-> ##2 (out == $past(A, 2) + $past(B, 2));
    endproperty

    property MULT_PROPERTY;
        @(posedge clk)
        disable iff(rst)  
        (opcode == MULT && !bypass_A && !bypass_B && !red_op_A && !red_op_B) |-> ##2 (out == $past(A, 2) * $past(B, 2));
    endproperty

    property SHIFT_LEFT_PROPERTY;
        @(posedge clk)
        disable iff(rst || bypass_A || bypass_B || red_op_A || red_op_B) 
        (opcode == SHIFT && direction == 1'b1) |-> ##2 (out == {$past(out[4:0]), $past(serial_in)});
    endproperty

    property SHIFT_RIGHT_PROPERTY;
        @(posedge clk)
        disable iff(rst || bypass_A || bypass_B || red_op_A || red_op_B)
        (opcode == SHIFT && direction == 1'b0) |-> ##2 (out == {$past(serial_in), $past(out[5:1])});
    endproperty

    property ROTATE_LEFT_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B || red_op_A || red_op_B) 
        (opcode == ROTATE && direction == 1'b1) |-> ##2 (out == {$past(out[4:0]), $past(out[5])});
    endproperty

    property ROTATE_RIGHT_PROPERTY;
        @(posedge clk) 
        disable iff(rst || bypass_A || bypass_B || red_op_A || red_op_B) 
        (opcode == ROTATE && direction == 1'b0) |-> ##2 (out == {$past(out[0]), $past(out[5:1])});
    endproperty

    property BYPASS_A_PROPERTY;
        @(posedge clk) 
        disable iff(rst)
        (bypass_A == 1'b1 && INPUT_PRIORITY == "A") |-> ##2 (out == $past(A, 2));
    endproperty

    property BYPASS_B_PROPERTY;
        @(posedge clk) 
        disable iff(rst)
        (bypass_B == 1'b1 && INPUT_PRIORITY == "B") |-> ##2 (out == $past(B, 2));
    endproperty

    property PRIORITY_A_BYPASS_PROPERTY;
        @(posedge clk) 
        disable iff(rst)
        (bypass_A == 1'b1 && bypass_B == 1'b1 &&  INPUT_PRIORITY == "A") |-> ##2 (out == $past(A, 2));
    endproperty

    property PRIORITY_B_BYPASS_PROPERTY;
        @(posedge clk) 
        disable iff(rst)
        (bypass_A == 1'b1 && bypass_B == 1'b1 &&  INPUT_PRIORITY == "B") |-> ##2 (out == $past(B, 2));
    endproperty

    always_comb begin
        if(rst)
            AS_RESET_PROPERTY: assert final(out == 6'b0 && leds == 16'b0);
    end

    INVALID_PROPERTY_ASSERT: assert property (INVALID_PROPERTY);
    INVALID_PROPERTY_COVER : cover  property (INVALID_PROPERTY);

    OR_A_PRIORITY_A_PROPERTY_ASSERT: assert property (OR_A_PRIORITY_A_PROPERTY);
    OR_A_PRIORITY_A_PROPERTY_COVER : cover  property (OR_A_PRIORITY_A_PROPERTY);

    OR_A_PRIORITY_B_PROPERTY_ASSERT: assert property (OR_A_PRIORITY_B_PROPERTY);
    OR_A_PRIORITY_B_PROPERTY_COVER : cover  property (OR_A_PRIORITY_B_PROPERTY);

    OR_B_PRIORITY_B_PROPERTY_ASSERT: assert property (OR_B_PRIORITY_B_PROPERTY);
    OR_B_PRIORITY_B_PROPERTY_COVER : cover  property (OR_B_PRIORITY_B_PROPERTY);

    OR_B_PRIORITY_A_PROPERTY_ASSERT: assert property (OR_B_PRIORITY_A_PROPERTY);
    OR_B_PRIORITY_A_PROPERTY_COVER : cover  property (OR_B_PRIORITY_A_PROPERTY);

    XOR_A_PRIORITY_A_PROPERTY_ASSERT: assert property (XOR_A_PRIORITY_A_PROPERTY);
    XOR_A_PRIORITY_A_PROPERTY_COVER : cover  property (XOR_A_PRIORITY_A_PROPERTY);

    XOR_A_PRIORITY_B_PROPERTY_ASSERT: assert property (XOR_A_PRIORITY_B_PROPERTY);
    XOR_A_PRIORITY_B_PROPERTY_COVER : cover  property (XOR_A_PRIORITY_B_PROPERTY);

    XOR_B_PRIORITY_B_PROPERTY_ASSERT: assert property (XOR_B_PRIORITY_B_PROPERTY);
    XOR_B_PRIORITY_B_PROPERTY_COVER : cover  property (XOR_B_PRIORITY_B_PROPERTY);

    XOR_B_PRIORITY_A_PROPERTY_ASSERT: assert property (XOR_B_PRIORITY_A_PROPERTY);
    XOR_B_PRIORITY_A_PROPERTY_COVER : cover  property (XOR_B_PRIORITY_A_PROPERTY);

    FULL_ADD_ON_PROPERTY_ASSERT: assert property (FULL_ADD_ON_PROPERTY);
    FULL_ADD_ON_PROPERTY_COVER : cover  property (FULL_ADD_ON_PROPERTY);

    FULL_ADD_OFF_PROPERTY_ASSERT: assert property (FULL_ADD_OFF_PROPERTY);
    FULL_ADD_OFF_PROPERTY_COVER : cover  property (FULL_ADD_OFF_PROPERTY);

    MULT_PROPERTY_ASSERT: assert property (MULT_PROPERTY);
    MULT_PROPERTY_COVER : cover  property (MULT_PROPERTY);

    SHIFT_LEFT_PROPERTY_ASSERT: assert property (SHIFT_LEFT_PROPERTY);
    SHIFT_LEFT_PROPERTY_COVER : cover  property (SHIFT_LEFT_PROPERTY);

    SHIFT_RIGHT_PROPERTY_ASSERT: assert property (SHIFT_RIGHT_PROPERTY);
    SHIFT_RIGHT_PROPERTY_COVER : cover  property (SHIFT_RIGHT_PROPERTY);
    
    ROTATE_LEFT_PROPERTY_ASSERT: assert property (ROTATE_LEFT_PROPERTY);
    ROTATE_LEFT_PROPERTY_COVER : cover  property (ROTATE_LEFT_PROPERTY);

    ROTATE_RIGHT_PROPERTY_ASSERT: assert property (ROTATE_RIGHT_PROPERTY);
    ROTATE_RIGHT_PROPERTY_COVER : cover  property (ROTATE_RIGHT_PROPERTY);

    BYPASS_A_PROPERTY_ASSERT: assert property (BYPASS_A_PROPERTY);
    BYPASS_A_PROPERTY_COVER : cover  property (BYPASS_A_PROPERTY);
   
    BYPASS_B_PROPERTY_ASSERT: assert property (BYPASS_B_PROPERTY);
    BYPASS_B_PROPERTY_COVER : cover  property (BYPASS_B_PROPERTY);

    PRIORITY_A_BYPASS_PROPERTY_ASSERT: assert property (PRIORITY_A_BYPASS_PROPERTY);
    PRIORITY_A_BYPASS_PROPERTY_COVER : cover  property (PRIORITY_A_BYPASS_PROPERTY);

    PRIORITY_B_BYPASS_PROPERTY_ASSERT: assert property (PRIORITY_B_BYPASS_PROPERTY);
    PRIORITY_B_BYPASS_PROPERTY_COVER : cover  property (PRIORITY_B_BYPASS_PROPERTY);

endmodule
