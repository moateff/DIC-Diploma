package alsu_pkg;

    typedef enum logic [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    
    typedef enum bit [2:0] {
        MAXNEG = 3'b100, 
        ZERO = 3'b000, 
        MAXPOS = 3'b011
    } input_val_e;

    parameter NUM_VALID_OPCODES = 6;

    class alsu_inputs;
        bit clk;
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
        bit [15:0] leds;
        bit signed [5:0] out;

        rand opcode_e opcode_seq [NUM_VALID_OPCODES];

        // c_rst: Reset should be asserted with a low probability
        constraint c_rst {
            rst dist {0 := 95, 1 := 5};
        }

        // c_ADD_MULT: Adder and Multiplier inputs favor MAXPOS, ZERO, MAXNEG
        constraint c_ADD_MULT {
            if (opcode == ADD || opcode == MULT) {
                A dist {MAXNEG := 30, ZERO := 30, MAXPOS := 30, [-3:-1] := 5, [1:2] := 5};
                B dist {MAXNEG := 30, ZERO := 30, MAXPOS := 30, [-3:-1] := 5, [1:2] := 5};
            }
        }

        // c_OR_XOR_A: OR/XOR with red_op_A => A one-hot, B zero
        constraint c_OR_XOR_A {
            if ((opcode inside {OR, XOR}) && red_op_A && !red_op_B) {
                A dist {3'b001 := 30, 3'b010 := 30, 3'b100 := 30, [3'b000:3'b111] := 10};
                B == 3'b000;
            }
        }

        // c_OR_XOR_B: OR/XOR with red_op_B => B one-hot, A zero
        constraint c_OR_XOR_B {
            if ((opcode inside {OR, XOR}) && red_op_B && !red_op_A) {
                B dist {3'b001 := 30, 3'b010 := 30, 3'b100 := 30, [3'b000:3'b111] := 10};
                A == 3'b000;
            }
        }

        // c_opcode: Invalid cases should occur less frequent than the valid cases 
        constraint c_opcode {
            opcode dist {[OR:ROTATE] := 80, [INVALID_6:INVALID_7] := 20};
        }

        // c_bypass: Bypass signals should be disabled most of the time
        constraint c_bypass {
            bypass_A dist {0 := 95, 1 := 5};
            bypass_B dist {0 := 95, 1 := 5};
        }
	
        constraint c_red_op {
            red_op_A dist {0 := 50, 1 := 50};
            red_op_B dist {0 := 50, 1 := 50};
        }

        // No constraints on A/B for shift/rotate handled implicitly
        
        constraint opcode_seq_c {
            foreach (opcode_seq[i]) {
                foreach (opcode_seq[j]) {
                    if (i != j) {
                        opcode_seq[i] != opcode_seq[j];
                        opcode_seq[i] inside {[OR:ROTATE]};
                    }
                }
            }
        }

        covergroup cg;
            A_cp :coverpoint A{
                bins A_data_0 = {0};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_walkingones[] = {3'b001,3'b010,3'b100} iff (red_op_A);
                bins A_data_default = default;
            }

            B_cp :coverpoint B{
                bins B_data_0 = {0};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_walkingones[] = {3'b001,3'b010,3'b100} iff (red_op_B && (!red_op_A));
                bins B_data_default = default;
            }

            opcode_cp :coverpoint opcode{
                bins Bins_shift[] = {SHIFT, ROTATE};
                bins Bins_arith[] = {ADD, MULT};
                bins Bins_bitwise[] = {OR, XOR};
                illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
                bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }
        endgroup
        
        function new();
            cg = new();
        endfunction

        task sample_cg();
            if((!rst) || (!bypass_A) || (!bypass_B)) begin
                @(negedge clk) cg.sample();
            end
        endtask
    endclass

endpackage : alsu_pkg
