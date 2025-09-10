package alsu_pkg;

  // Opcode enum including invalid cases
  typedef enum logic [2:0] {OR, XOR, ADD, MUL, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;

  // Named values for easier referencing in constraints
  typedef enum bit signed [2:0] {MAXNEG = -4, ZERO = 0, MAXPOS = 3} input_val_e;

  class alsu_input;
    rand bit rst;
    rand bit cin;
    rand bit red_op_A;
    rand bit red_op_B;
    rand bit bypass_A;
    rand bit bypass_B;
    rand bit direction;
    rand bit serial_in;
    rand opcode_e opcode;
    rand bit signed [2:0] A;
    rand bit signed [2:0] B;

    // c_rst: Reset should be asserted with a low probability
    constraint c_rst {
      rst dist {0 := 95, 1 := 5};
    }

    // c_ADD_MUL: Adder and Multiplier inputs favor MAXPOS, ZERO, MAXNEG
    constraint c_ADD_MUL {
      if (opcode == ADD || opcode == MUL) {
        A dist {MAXNEG := 30, ZERO := 30, MAXPOS := 30, [-3:-1] := 5, [1:2] := 5};
        B dist {MAXNEG := 30, ZERO := 30, MAXPOS := 30, [-3:-1] := 5, [1:2] := 5};
      }
    }

    // c_OR_XOR_A: OR/XOR with red_op_A => A one-hot, B zero
    constraint c_OR_XOR_A {
      if ((opcode inside {OR, XOR}) && red_op_A && !red_op_B) {
        A inside {3'b001, 3'b010, 3'b100};
        B == 3'b000;
      }
    }

    // c_OR_XOR_B: OR/XOR with red_op_B => B one-hot, A zero
    constraint c_OR_XOR_B {
      if ((opcode inside {OR, XOR}) && red_op_B && !red_op_A) {
        B inside {3'b001, 3'b010, 3'b100};
        A == 3'b000;
      }
    }

    // c_INVALID_CASES: Invalid red_op and opcode combinations occur less often
    constraint c_INVALID_CASES {
      !( (red_op_A || red_op_B) && (opcode[2] || opcode[1]) );
    }

    // c_bypass: Bypass signals should be disabled most of the time
    constraint c_bypass {
      bypass_A dist {0 := 80, 1 := 20};
      bypass_B dist {0 := 80, 1 := 20};
    }

    // Note: No constraints on A/B for shift/rotate handled implicitly

  endclass

endpackage
