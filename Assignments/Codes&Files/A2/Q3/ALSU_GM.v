module ALSU_GM #(
    parameter INPUT_PRIORITY = "A",
    parameter FULL_ADDER = "ON")
    (
    input signed [2:0] A, B,
    input [2:0] opcode,
    input clk, rst, cin, serial_in, direction,
    input red_op_A, red_op_B, bypass_A, bypass_B,

    output reg [15:0] leds,
    output reg signed [5:0] out
);

// Signals Sampling 
reg signed [2:0] A_reg, B_reg; 
reg [2:0] opcode_reg;
reg signed cin_reg;
reg serial_in_reg, direction_reg;
reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg;

always@(posedge clk or posedge rst) begin
    if(rst) begin 
        A_reg <= 0; 
        B_reg <= 0; 
        opcode_reg <= 0;
        cin_reg <= 0;
        serial_in_reg <= 0;
        direction_reg <= 0;
        red_op_A_reg <= 0;
        red_op_B_reg <= 0;
        bypass_A_reg <= 0;
        bypass_B_reg <= 0;
    end
    else begin
        A_reg <= A; 
        B_reg <= B; 
        opcode_reg <= opcode;
        cin_reg <= cin;
        serial_in_reg <= serial_in;
        direction_reg <= direction;
        red_op_A_reg <= red_op_A;
        red_op_B_reg <= red_op_B;
        bypass_A_reg <= bypass_A;
        bypass_B_reg <= bypass_B;    
    end
end

wire invalid_red_op, invalid_opcode, invalid;

//Invalid Cases
assign invalid = ((red_op_A_reg || red_op_B_reg) &&
                 !(opcode_reg == 3'b000 || opcode_reg == 3'b001)) ||
                 (opcode_reg == 3'b110 || opcode_reg == 3'b111);

always @(posedge clk or posedge rst) begin
  if(rst) begin
     leds <= 0;
  end else begin
      if (invalid)
        leds <= ~leds;
      else
        leds <= 0;
  end
end

//ALSU Logic 
always@(posedge clk or posedge rst) begin
    if(rst) 
        out <= 0;
    else begin
        if (bypass_A_reg && bypass_B_reg)
            out <= (INPUT_PRIORITY == "A")? A_reg: B_reg;

        else if (bypass_A_reg)
            out <= A_reg;

        else if (bypass_B_reg)
            out <= B_reg;

        else if (invalid)
            out <= 0;
        else begin
            case(opcode_reg)
            3'b000: begin
                if(red_op_A_reg && red_op_B_reg)
                    out <= (INPUT_PRIORITY == "A")? |A_reg : |B_reg;
                else if (red_op_A_reg)
                    out <= |A_reg;
                else if (red_op_B_reg)
                    out <= |B_reg;
                else 
                    out <= A_reg | B_reg;
            end
            3'b001: begin
                if(red_op_A_reg && red_op_B_reg)
                    out <= (INPUT_PRIORITY == "A")? ^A_reg : ^B_reg;
                else if (red_op_A_reg) 
                    out <= ^A_reg;
                else if (red_op_B_reg)
                    out <= ^B_reg;
                else 
                    out <= A_reg ^ B_reg;
            end
            3'b010: begin
                if(FULL_ADDER == "ON")
                    out <= A_reg + B_reg + cin_reg;
                else
                    out <= A_reg + B_reg;    
            end
            3'b011:
                out <= A_reg * B_reg;
            3'b100: begin
                if (direction_reg)
                out <= {out[4:0], serial_in_reg};
                else
                out <= {serial_in_reg, out[5:1]};
            end
            3'b101: begin
                if (direction_reg)
                out <= {out[4:0], out[5]};
                else
                out <= {out[0], out[5:1]};
            end
            endcase
        end
    end
end

endmodule