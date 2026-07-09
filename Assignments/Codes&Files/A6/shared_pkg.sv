package shared_pkg;
    typedef enum logic [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e; 
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    parameter MAXPOS = 3;
    parameter MAXNEG = -4;
    parameter ZERO = 0;
endpackage