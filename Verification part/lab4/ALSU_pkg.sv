package alsu_pkg;

    typedef enum {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    
    typedef enum {
        MAXNEG = -4, 
        ZERO = 0, 
        MAXPOS = 3
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
            ADD_MULT_A_cp: coverpoint A{
                bins A_data_0 = {0};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
            }

            RED_A_cp: coverpoint A iff (red_op_A){
                bins A_data_walkingones[] = {3'sb001,3'sb010,3'sb100} iff (red_op_A);
            }

            ADD_MULT_B_cp: coverpoint B{
                bins B_data_0 = {0};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
            }

            RED_B_cp: coverpoint B iff (red_op_B && (!red_op_A)){
                bins B_data_walkingones[] = {3'sb001,3'sb010,3'sb100};
            }

            opcode_cp: coverpoint opcode{
                bins bins_shift[] = {SHIFT, ROTATE};
                bins bins_arith[] = {ADD, MULT};
                bins bins_bitwise[] = {OR, XOR};
                illegal_bins bins_invalid = {INVALID_6, INVALID_7};
                bins bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }

            opcode_shift_cp: coverpoint opcode{
                option.weight = 0;
                bins bins_shift[] = {SHIFT, ROTATE};
            }

            opcode_arith_cp: coverpoint opcode{
                option.weight = 0;
                bins bins_arith[] = {ADD, MULT};
            }

            opcode_bitwise_cp: coverpoint opcode{
                option.weight = 0;
                bins bins_arith[] = {OR, XOR};
            }

            opcode_not_bitwise_cp: coverpoint opcode{
                option.weight = 0;
                bins bins_not_bitwise[] = {[ADD:$]};
            }

            ADD_MULT_cross: cross ADD_MULT_A_cp, ADD_MULT_B_cp, opcode_arith_cp;

            ADD_cin_cross: cross cin, opcode_arith_cp{
                option.cross_auto_bin_max = 0;
                bins cin_0 = binsof(opcode_arith_cp.bins_arith) intersect {ADD} && 
                            binsof(cin) intersect {0};
                bins cin_1 = binsof(opcode_arith_cp.bins_arith) intersect {ADD} && 
                            binsof(cin) intersect {1};
            }

            SHIFT_direction_cross: cross direction, opcode_shift_cp{
                option.cross_auto_bin_max = 0;
                bins direction_0 = binsof(opcode_shift_cp.bins_shift) && 
                            binsof(direction) intersect {0};
                bins direction_1 = binsof(opcode_shift_cp.bins_shift) && 
                            binsof(direction) intersect {1};
            }

            SHIFT_serial_in_cross: cross serial_in, opcode_shift_cp{
                option.cross_auto_bin_max = 0;
                bins serial_in_0 = binsof(opcode_shift_cp.bins_shift) intersect {SHIFT} && 
                            binsof(serial_in) intersect {0};
                bins serial_in_1 = binsof(opcode_shift_cp.bins_shift) intersect {SHIFT} && 
                            binsof(serial_in) intersect {1};
            }

            red_op_A_cross: cross RED_A_cp, ADD_MULT_B_cp, opcode_bitwise_cp iff (red_op_A){
                ignore_bins B_data_max = binsof(ADD_MULT_B_cp.B_data_max);
                ignore_bins B_data_min = binsof(ADD_MULT_B_cp.B_data_min);
            }

            red_op_B_cross: cross RED_B_cp, ADD_MULT_A_cp, opcode_bitwise_cp iff (red_op_B && (!red_op_A)){
                ignore_bins A_data_max = binsof(ADD_MULT_A_cp.A_data_max);
                ignore_bins A_data_min = binsof(ADD_MULT_A_cp.A_data_min);
            }

            invalid_red_op_A_cross: cross red_op_A, opcode_not_bitwise_cp{
                ignore_bins red_op_A_0 = binsof(red_op_A) intersect {0};
                illegal_bins red_op_A_1 = binsof(red_op_A) intersect {1};
            }

            invalid_red_op_B_cross: cross red_op_B, opcode_not_bitwise_cp{
                ignore_bins red_op_B_0 = binsof(red_op_B) intersect {0};
                illegal_bins red_op_B_1 = binsof(red_op_B) intersect {1};
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

endpackage:  alsu_pkg
