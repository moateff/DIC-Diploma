import alsu_shared_pkg::*;

module alsu_sva #(
    parameter INPUT_PRIORITY = "A",
    parameter FULL_ADDER = "ON"
) (
    input  logic               clk,
    input  logic               rst,
    input  logic               cin,
    input  logic               red_op_A,
    input  logic               red_op_B,
    input  logic               bypass_A,
    input  logic               bypass_B,
    input  logic               direction,
    input  logic        	   serial_in,
    input  logic        [2:0]  opcode,
    input  logic signed [2:0]  A,
    input  logic signed [2:0]  B,
    input  logic        [15:0] leds,
    input  logic signed [5:0]  out
);

    logic invalid_red_op, invalid_opcode, invalid;

    assign invalid_red_op = (red_op_A | red_op_B) & (opcode[1] | opcode[2]);
    assign invalid_opcode = opcode[1] & opcode[2];
    assign invalid        = invalid_red_op | invalid_opcode;

    always_comb begin 
        if (rst) begin
            assert_reset_leds: assert final(leds == 16'b0);
        end 
    end

    property invalid_leds_p;
        @(posedge clk) disable iff (rst) (invalid) |-> ##2 (leds == ~$past(leds));
    endproperty

    property valid_leds_p;
        @(posedge clk) disable iff (rst) (!invalid) |-> ##2 (leds == 16'b0);
    endproperty

    always_comb begin 
        if (rst) begin
            assert_reset_out: assert final(out == 6'b0);
        end 
    end

    property priority_bypass_A_p;
        @(posedge clk) disable iff (rst)
            (bypass_A && bypass_B && INPUT_PRIORITY == "A") |-> ##2 (out == $past(A, 2));
    endproperty

    property priority_bypass_B_p;
        @(posedge clk) disable iff (rst)
            (bypass_A && bypass_B && INPUT_PRIORITY == "B") |-> ##2 (out == $past(B, 2));
    endproperty

    property bypass_A_p;
        @(posedge clk) disable iff (rst)
            (bypass_A && !bypass_B) |-> ##2 (out == $past(A, 2));
    endproperty

    property bypass_B_p;
        @(posedge clk) disable iff (rst)
            (!bypass_A && bypass_B) |-> ##2 (out == $past(B, 2));
    endproperty

    property invalid_out_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && invalid) |-> ##2 (out == 6'b0);
    endproperty

    property red_or_priority_A_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == OR && red_op_A && red_op_B && INPUT_PRIORITY == "A") |-> ##2
            (out == |$past(A, 2));
    endproperty

    property red_or_priority_B_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == OR && red_op_A && red_op_B && INPUT_PRIORITY == "B") |-> ##2
            (out == |$past(B, 2));
    endproperty

    property red_or_A_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == OR && red_op_A && !red_op_B) |-> ##2
            (out == |$past(A, 2));
    endproperty

    property red_or_B_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == OR && !red_op_A && red_op_B) |-> ##2
            (out == |$past(B, 2));
    endproperty

    property or_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == OR && !red_op_A && !red_op_B) |-> ##2
            (out == $past(A, 2) | $past(B, 2));
    endproperty

    property red_xor_priority_A_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == XOR && red_op_A && red_op_B && INPUT_PRIORITY == "A") |-> ##2
            (out == ^$past(A, 2));
    endproperty

    property red_xor_priority_B_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == XOR && red_op_A && red_op_B && INPUT_PRIORITY == "B") |-> ##2
            (out == ^$past(B, 2));
    endproperty

    property red_xor_A_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == XOR && red_op_A && !red_op_B) |-> ##2
            (out == ^$past(A, 2));
    endproperty

    property red_xor_B_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == XOR && !red_op_A && red_op_B) |-> ##2
            (out == ^$past(B, 2));
    endproperty

    property xor_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == XOR && !red_op_A && !red_op_B) |-> ##2
            (out == $past(A, 2) ^ $past(B, 2));
    endproperty

    property full_add_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == ADD && FULL_ADDER == "ON") |-> ##2
            (out == $past(A, 2) + $past(B, 2) + $past(cin, 2));
    endproperty

    property half_add_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == ADD && FULL_ADDER == "OFF") |-> ##2
            (out == $past(A, 2) + $past(B, 2));
    endproperty

    property mult_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == MULT) |-> ##2
            (out == $past(A, 2) * $past(B, 2));
    endproperty

    property right_shift_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == SHIFT && direction == RIGHT) |-> ##2
            (out == {$past(serial_in,2), $past(out[5:1])});
    endproperty

    property left_shift_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == SHIFT && direction == LEFT) |-> ##2
            (out == {$past(out[4:0]), $past(serial_in, 2)});
    endproperty

    property right_rotate_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == ROTATE && direction == RIGHT) |-> ##2
                (out =={$past(out[0]), $past(out[5:1])});
    endproperty

    property left_rotate_opcode_p;
        @(posedge clk) disable iff (rst) 
            (!bypass_A && !bypass_B && !invalid && opcode == ROTATE && direction == LEFT) |-> ##2
            (out =={$past(out[4:0]), $past(out[5])});
    endproperty


    assert_invalid_leds_p: assert property(invalid_leds_p);
    assert_valid_leds_p: assert property(valid_leds_p);
    assert_priority_bypass_A_p: assert property(priority_bypass_A_p);
    assert_priority_bypass_B_p: assert property(priority_bypass_B_p);
    assert_invalid_out_p: assert property(invalid_out_p);
    assert_red_or_priority_A_p: assert property(red_or_priority_A_p);
    assert_red_or_priority_B_p: assert property(red_or_priority_B_p);
    assert_red_or_A_p: assert property(red_or_A_p);
    assert_red_or_B_p: assert property(red_or_B_p);
    assert_or_opcode_p: assert property(or_opcode_p);
    assert_red_xor_priority_A_p: assert property(red_xor_priority_A_p);
    assert_red_xor_priority_B_p: assert property(red_xor_priority_B_p);
    assert_red_xor_A_p: assert property(red_xor_A_p);
    assert_red_xor_B_p: assert property(red_xor_B_p);
    assert_xor_opcode_p: assert property(xor_opcode_p);
    assert_full_add_opcode_p: assert property(full_add_opcode_p);
    assert_half_add_opcode_p: assert property(half_add_opcode_p);
    assert_mult_opcode_p: assert property(mult_opcode_p);
    assert_right_shift_opcode_p: assert property(right_shift_opcode_p);
    assert_left_shift_opcode_p: assert property(left_shift_opcode_p);
    assert_right_rotate_opcode_p: assert property(right_rotate_opcode_p);
    assert_left_rotate_opcode_p: assert property(left_rotate_opcode_p);

    cover_invalid_leds_p: cover property(invalid_leds_p);
    cover_valid_leds_p: cover property(valid_leds_p);
    cover_priority_bypass_A_p: cover property(priority_bypass_A_p);
    cover_priority_bypass_B_p: cover property(priority_bypass_B_p);
    cover_invalid_out_p: cover property(invalid_out_p);
    cover_red_or_priority_A_p: cover property(red_or_priority_A_p);
    cover_red_or_priority_B_p: cover property(red_or_priority_B_p);
    cover_red_or_A_p: cover property(red_or_A_p);
    cover_red_or_B_p: cover property(red_or_B_p);
    cover_or_opcode_p: cover property(or_opcode_p);
    cover_red_xor_priority_A_p: cover property(red_xor_priority_A_p);
    cover_red_xor_priority_B_p: cover property(red_xor_priority_B_p);
    cover_red_xor_A_p: cover property(red_xor_A_p);
    cover_red_xor_B_p: cover property(red_xor_B_p);
    cover_xor_opcode_p: cover property(xor_opcode_p);
    cover_full_add_opcode_p: cover property(full_add_opcode_p);
    cover_half_add_opcode_p: cover property(half_add_opcode_p);
    cover_mult_opcode_p: cover property(mult_opcode_p);
    cover_right_shift_opcode_p: cover property(right_shift_opcode_p);
    cover_left_shift_opcode_p: cover property(left_shift_opcode_p);
    cover_right_rotate_opcode_p: cover property(right_rotate_opcode_p);
    cover_left_rotate_opcode_p: cover property(left_rotate_opcode_p);

endmodule