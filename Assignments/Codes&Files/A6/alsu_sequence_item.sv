package alsu_sequence_item_pkg;
import uvm_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"

    class alsu_seq_item extends uvm_sequence_item;
        `uvm_object_utils(alsu_seq_item)
        rand logic cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand opcode_e opcode;
        rand logic signed [2:0] A, B;
        
        logic [15:0] leds;
        logic signed [5:0] out;   

        constraint opcode_con{
            opcode dist {[OR:ROTATE] := 80, INVALID_6 := 10, INVALID_7 := 10};
        }
        constraint rst_con{
            rst dist {0:= 90, 1:= 10};
        }

        constraint bypass_con{
            bypass_A dist {0:= 90, 1:=10}; 
            bypass_B dist {0:= 90, 1:=10}; 
        }

        constraint A_B_con{
            if(opcode inside {ADD, MULT}) {
            A dist {MAXPOS := 80, MAXNEG := 80, ZERO := 80, -3 := 20,
                    -2 := 20, -1 := 20, 1  := 20, 2  := 20};

            B dist {MAXPOS := 80, MAXNEG := 80, ZERO := 80, -3 := 20,
                    -2 := 20, -1 := 20, 1  := 20, 2  := 20};
            }
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
            else 
                direction dist {0:=50, 1:= 80};
            }

        rand opcode_e my_array [6];
        constraint unique_opcode_con{
            unique{my_array};
            foreach(my_array[i])
                my_array[i] inside {[OR:ROTATE]};
        }

        function new(string name = "alsu_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s cin=%0d, rst=%0d, red_op_A=%0d, red_op_B=%0d, bypass_A=%0d, bypass_B=%0d, direction=%0d, serial_in=%0d, opcode=%0s, A=%0d, B=%0d, leds=%0d, out=%0d",
                            super.convert2string(),
                            cin, rst, red_op_A, red_op_B, bypass_A, bypass_B,
                            direction, serial_in, opcode, A, B, leds, out);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("cin=%0d, rst=%0d, red_op_A=%0d, red_op_B=%0d, bypass_A=%0d, bypass_B=%0d, direction=%0d, serial_in=%0d, opcode=%0s, A=%0d, B=%0d",
                            cin, rst, red_op_A, red_op_B, bypass_A, bypass_B,
                            direction, serial_in, opcode, A, B);
        endfunction
    endclass
endpackage