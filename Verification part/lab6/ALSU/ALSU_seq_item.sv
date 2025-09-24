package alsu_seq_item_pkg;
import uvm_pkg::*;
import alsu_shared_pkg::*;
`include "uvm_macros.svh"

class alsu_seq_item extends uvm_sequence_item;
    `uvm_object_utils(alsu_seq_item)

    rand bit rst;
    rand bit cin;
    rand bit red_op_A;
    rand bit red_op_B;
    rand bit bypass_A;
    rand bit bypass_B;
    rand direction_e direction;
    rand bit serial_in;
    rand opcode_e opcode;
    rand bit signed [2:0] A;
    rand bit signed [2:0] B;
    logic [15:0] leds;
    logic signed [5:0] out;

    function new(string name = "alsu_seq_item");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf("%s rst = %0b, A = 0b%0b, B = 0b%0b, opcode = %0s, cin = %0b, red_op_A = %0b, red_op_B = %0b, bypass_A = %0b, bypass_B = %0b, direction = %s, serial_in = %0b, out = 0b%0b, leds = 0x%0h ", 
            super.convert2string(), rst, A, B, opcode, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, out, leds);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("rst = %0b, A = 0b%0b, B = 0b%0b, opcode = %0s, cin = %0b, red_op_A = %0b, red_op_B = %0b, bypass_A = %0b, bypass_B = %0b, direction = %s, serial_in = %0b",
                    rst, A, B, opcode, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in);
    endfunction

    constraint c_rst {
        rst dist {0 := 95, 1 := 5};
    }

    constraint c_ADD_MULT {
        if (opcode == ADD || opcode == MULT) {
            A dist {MAXNEG := 30, ZERO := 30, MAXPOS := 30, [-3:-1] := 5, [1:2] := 5};
            B dist {MAXNEG := 30, ZERO := 30, MAXPOS := 30, [-3:-1] := 5, [1:2] := 5};
        }
    }

    constraint c_OR_XOR_A {
        if ((opcode inside {OR, XOR}) && red_op_A && !red_op_B) {
            A dist {3'b001 := 30, 3'b010 := 30, 3'b100 := 30, [3'b000:3'b111] := 10};
            B == 3'b000;
        }
    }

    constraint c_OR_XOR_B {
        if ((opcode inside {OR, XOR}) && red_op_B && !red_op_A) {
            B dist {3'b001 := 30, 3'b010 := 30, 3'b100 := 30, [3'b000:3'b111] := 10};
            A == 3'b000;
        }
    }

    constraint c_opcode {
        opcode dist {[OR:ROTATE] := 80, [INVALID_6:INVALID_7] := 20};
    }

    constraint c_bypass {
        bypass_A dist {0 := 95, 1 := 5};
        bypass_B dist {0 := 95, 1 := 5};
    }

    constraint c_red_op {
        red_op_A dist {0 := 50, 1 := 50};
        red_op_B dist {0 := 50, 1 := 50};
    }
endclass

endpackage: alsu_seq_item_pkg