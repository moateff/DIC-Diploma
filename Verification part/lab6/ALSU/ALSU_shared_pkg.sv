package alsu_shared_pkg;

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";

    typedef enum bit [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    
    typedef enum bit {RIGHT, LEFT} direction_e;
    
    typedef enum {
        MAXNEG = -4, 
        ZERO = 0, 
        MAXPOS = 3
    } input_val_e;

endpackage: alsu_shared_pkg