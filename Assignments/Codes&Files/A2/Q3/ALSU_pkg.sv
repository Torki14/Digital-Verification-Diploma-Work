package ALSU_pkg; 
typedef enum logic [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e; 

parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";

localparam MAXPOS = 3;
localparam MAXNEG = -4;
localparam ZERO = 0;

class ALSU_class;
    rand logic rst, cin, serial_in, direction, red_op_A, red_op_B, bypass_A, bypass_B;
    rand opcode_e opcode;
    rand logic signed [2:0] A, B;
    
    constraint c {     
        //ALSU_1
        opcode dist {OR := 80, XOR := 80, ADD := 80, MULT := 80, SHIFT := 80, 
                     ROTATE := 80, INVALID_6 := 20, INVALID_7 := 20};
        //ALSU_2
        bypass_A dist {0:= 90, 1:=10}; 
        bypass_B dist {0:= 90, 1:=10}; 
        
        //ALSU_3
        rst dist {0:= 90, 1:= 10};

        //ALSU_4
        if(opcode inside {ADD, MULT}) {
            A dist {MAXPOS := 80, MAXNEG := 80, ZERO := 80, -3 := 20,
                    -2 := 20, -1 := 20, 1  := 20, 2  := 20};

            B dist {MAXPOS := 80, MAXNEG := 80, ZERO := 80, -3 := 20,
                    -2 := 20, -1 := 20, 1  := 20, 2  := 20};
        }
        //ALSU_5
        else if (opcode inside {OR, XOR}) {
            red_op_A dist {0:=50, 1:= 50}; 
            red_op_B dist {0:=50, 1:= 50};
            if(red_op_A) {
                A dist {
                    3'b001 := 70,
                    3'b010 := 70,
                    3'b100 := 70,

                    3'b011 := 20,
                    3'b101 := 20,
                    3'b110 := 20,

                    3'b000 := 10,
                    3'b111 := 10
                };
                B == 0;
            }
            else if (red_op_B) {
                B dist {
                    3'b001 := 70,
                    3'b010 := 70,
                    3'b100 := 70,

                    3'b011 := 20,
                    3'b101 := 20,
                    3'b110 := 20,

                    3'b000 := 10,
                    3'b111 := 10
                };
                A == 0;
            }

        }
        //ALSU_6
        else 
            direction dist {0:=50, 1:= 80};
    }   
function new();
    this.rst = 0;
    this.cin = 0;
    this.serial_in = 0;
    this.direction = 0;
    this.red_op_A = 0;
    this.red_op_B = 0;
    this.bypass_A = 0;
    this.bypass_B = 0;
    this.opcode = OR;
    this.A = 0;
    this.B = 0;
    endfunction
endclass

endpackage