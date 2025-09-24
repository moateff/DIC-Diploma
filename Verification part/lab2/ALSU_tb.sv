`timescale 1ns / 1ps

import alsu_pkg::*;

module alsu_tb;
    // TESTBENCH VARIABLES
    int NUM_TEST_CASES = 1000;
    int local_error_count = 0;
    int error_count = 0;
    int pass_count = 0;
    
    // DUT 
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    bit clk;
    bit rst;
    bit cin;
    bit red_op_A;
    bit red_op_B;
    bit bypass_A;
    bit bypass_B;
    bit direction;
    bit serial_in;
    opcode_e opcode;
    bit signed [2:0] A;
    bit signed [2:0] B;
    logic [15:0] leds;
    logic signed [5:0] out;

    // GOLDEN MODEL
    logic signed [5:0] golden_out;
    logic [15:0] golden_leds;
    
    ALSU #(
        .INPUT_PRIORITY(INPUT_PRIORITY), 
        .FULL_ADDER(FULL_ADDER)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .cin(cin),
        .red_op_A(red_op_A),
        .red_op_B(red_op_B),
        .bypass_A(bypass_A),
        .bypass_B(bypass_B),    
        .direction(direction),
        .serial_in(serial_in),
        .opcode(opcode),
        .A(A),
        .B(B),
        .leds(leds),
        .out(out)
    );

    ALSU_golden #(
        .INPUT_PRIORITY(INPUT_PRIORITY), 
        .FULL_ADDER(FULL_ADDER)
    ) GOLDEN (
        .clk(clk),
        .rst(rst),
        .cin(cin),
        .red_op_A(red_op_A),
        .red_op_B(red_op_B),
        .bypass_A(bypass_A),
        .bypass_B(bypass_B),    
        .direction(direction),
        .serial_in(serial_in),
        .opcode(opcode),
        .A(A),
        .B(B),
        .leds(golden_leds),
        .out(golden_out)
    );

    alsu_inputs alsu_obj;
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Starting ALSU testbench...");
        alsu_obj = new();

        assert_reset();
        check_result();

        repeat(NUM_TEST_CASES) begin
            wait_cycles(1);
            assert(alsu_obj.randomize());
            rst = alsu_obj.rst;
            cin = alsu_obj.cin;
            red_op_A = alsu_obj.red_op_A;
            red_op_B = alsu_obj.red_op_B;
            bypass_A = alsu_obj.bypass_A;
            bypass_B = alsu_obj.bypass_B;
            direction = alsu_obj.direction;
            serial_in = alsu_obj.serial_in;
            opcode = alsu_obj.opcode;
            A = alsu_obj.A;
            B = alsu_obj.B;
            check_result();
        end
	
	// Display completion message
        $display("Simulation Completed: %0d test cases executed.", NUM_TEST_CASES);
        $display("Test Summary: Passed = %0d, Failed = %0d", pass_count, error_count);
	$stop;
    end

    task wait_cycles(input int num_cycles);
        repeat (num_cycles) @(negedge clk);
    endtask

    task assert_reset();
        wait_cycles(1);
        rst = 1;
        wait_cycles(1);
        rst = 0;
    endtask
    
    task check_result();
        local_error_count = 0;

        if (out !== golden_out) begin
            $error("[ERROR] out mismatch. Expected: %0d, Got: %0d", golden_out, out);
            local_error_count++;
        end

        if (leds !== golden_leds) begin
            $error("[ERROR] leds mismatch. Expected: %b, Got: %b", golden_leds, leds);
            local_error_count++;
        end

        if (local_error_count == 0) begin
            pass_count++;
            $display("[PASS] Outputs match expected values.");
        end else begin
            error_count++;
            $display("[FAIL] Total mismatches in this check: %0d", local_error_count);
        end
    endtask

endmodule
