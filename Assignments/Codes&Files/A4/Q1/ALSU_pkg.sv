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
    bit clk;
    
    covergroup g1;
        //ALSU_0
        A_cp: coverpoint A {
            bins A_data_0 = {ZERO};
            bins A_data_max = {MAXPOS};
            bins A_data_min = {MAXNEG};
            bins A_corner   = {ZERO, MAXPOS, MAXNEG};
            bins A_data_default = default;
            bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100} iff(red_op_A);
        }
        //ALSU_1
        B_cp: coverpoint B {
            bins B_data_0 = {ZERO};
            bins B_data_max = {MAXPOS};
            bins B_data_min = {MAXNEG};
            bins B_corner   = {ZERO, MAXPOS, MAXNEG};
            bins B_data_default = default;
            bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100} iff(red_op_B && !red_op_A);
        }
        //ALSU_2
        ALU_cp: coverpoint opcode {
            bins Bins_shift[] = {SHIFT, ROTATE};
            bins Bins_arith[] = {ADD, MULT};
            bins Bins_bitwise[] = {OR, XOR};
            illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
            bins Bins_trans = (OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE);        
        }

        cin_cp: coverpoint cin {
            bins cin_0 = {0};
            bins cin_1 = {1};
        }

        direction_cp: coverpoint direction {
            bins direction_0 = {0};
            bins direction_1 = {1};
        }

        serial_in_cp: coverpoint serial_in {
            bins serial_in_0 = {0};
            bins serial_in_1 = {1};
        }

        red_op_A_cp: coverpoint red_op_A {
            bins red_op_A_0 = {0};
            bins red_op_A_1 = {1};
        }

        red_op_B_cp: coverpoint red_op_B {
            bins red_op_B_0 = {0};
            bins red_op_B_1 = {1};
        }

        Cross_cov: cross  A_cp, B_cp, ALU_cp, red_op_A_cp, red_op_B_cp, direction_cp, serial_in_cp, cin_cp {
            option.cross_auto_bin_max = 0;
            //ALSU_10
            bins ARITH_AMP_BMP = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_max) && binsof(B_cp.B_data_max);
            bins ARITH_AMP_BMN = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_max) && binsof(B_cp.B_data_min);
            bins ARITH_AMP_BZE = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_max) && binsof(B_cp.B_data_0);

            bins ARITH_AMN_BMP = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_min) && binsof(B_cp.B_data_max);
            bins ARITH_AMN_BMN = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_min) && binsof(B_cp.B_data_min);
            bins ARITH_AMN_BZE = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_min) && binsof(B_cp.B_data_0);

            bins ARITH_AZE_BMP = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_0) && binsof(B_cp.B_data_max);
            bins ARITH_AZE_BMN = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_0) && binsof(B_cp.B_data_min);
            bins ARITH_AZE_BZE = binsof(ALU_cp.Bins_arith) && binsof(A_cp.A_data_0) && binsof(B_cp.B_data_0);

            //ALSU_11
            bins ADD_CARRY0    = binsof(ALU_cp) intersect {ADD} && binsof(cin_cp.cin_0); 
            bins ADD_CARRY1    = binsof(ALU_cp) intersect {ADD} && binsof(cin_cp.cin_1); 

            //ALSU_12
            bins SHFT_ROR_DIR0 = binsof(ALU_cp.Bins_shift) && binsof(direction_cp.direction_0);
            bins SHFT_ROR_DIR1 = binsof(ALU_cp.Bins_shift) && binsof(direction_cp.direction_1);

            //ALSU_13
            bins SHIFT_IN0     = binsof(ALU_cp) intersect {SHIFT} && binsof(serial_in_cp.serial_in_0);
            bins SHIFT_IN1     = binsof(ALU_cp) intersect {SHIFT} && binsof(serial_in_cp.serial_in_1);

            //ALSU_14
            bins BITWISE_PAT_0 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_1) && 
                                 binsof(A_cp.A_data_walkingones[0]) && binsof(B_cp.B_data_0);
            bins BITWISE_PAT_1 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_1) && 
                                 binsof(A_cp.A_data_walkingones[1]) && binsof(B_cp.B_data_0);
            bins BITWISE_PAT_2 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_1) && 
                                 binsof(A_cp.A_data_walkingones[2]) && binsof(B_cp.B_data_0);
            
            //ALSU_15
            bins BITWISE_PAT_3 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_1) && 
                                 binsof(B_cp.B_data_walkingones[0]) && binsof(A_cp.A_data_0);
            bins BITWISE_PAT_4 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_1) && 
                                 binsof(B_cp.B_data_walkingones[1]) && binsof(A_cp.A_data_0);
            bins BITWISE_PAT_5 = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_1) && 
                                 binsof(B_cp.B_data_walkingones[2]) && binsof(A_cp.A_data_0);

            //ALSU_16
            illegal_bins INVALID_RED_OP_A  = binsof(red_op_A_cp.red_op_A_1) && (binsof(ALU_cp.Bins_arith) ||
                                                                                binsof(ALU_cp.Bins_shift));  
            illegal_bins INVALID_RED_OP_B  = binsof(red_op_B_cp.red_op_B_1) && (binsof(ALU_cp.Bins_arith) ||
                                                                                binsof(ALU_cp.Bins_shift));                 
        }

    endgroup

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
    g1 = new();
    endfunction
endclass
endpackage