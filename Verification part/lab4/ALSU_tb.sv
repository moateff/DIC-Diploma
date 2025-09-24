`timescale 1ns / 1ps

import alsu_pkg::*;

module alsu_tb;
    // TESTBENCH VARIABLES
    int NUM_TEST_CASES = 3000;
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

    alsu_inputs alsu_obj = new();
    
    initial begin
        clk = 0;
        forever begin 
            #5 clk = ~clk;
            alsu_obj.clk = clk;
        end
    end

    initial begin
        $display("Starting ALSU testbench...");
        assert_reset();
        alsu_obj.opcode_seq_c.constraint_mode(0);

        repeat(NUM_TEST_CASES/2) begin
            assert(alsu_obj.randomize());
            drive_inputs(alsu_obj);
            wait_cycles(1);
            golden_model(alsu_obj);
            wait_cycles(1);
            check_result(alsu_obj);
            alsu_obj.sample_cg();
        end

        alsu_obj.constraint_mode(0);
        alsu_obj.opcode_seq_c.constraint_mode(1);
        alsu_obj.red_op_A = 0;
        alsu_obj.red_op_B = 0;
        alsu_obj.bypass_A = 0;
        alsu_obj.bypass_B = 0;
        alsu_obj.rst = 0;

        repeat(NUM_TEST_CASES/2) begin
            assert(alsu_obj.randomize());
            foreach(alsu_obj.opcode_seq[i]) begin
                alsu_obj.opcode = alsu_obj.opcode_seq[i];
                drive_inputs(alsu_obj);
                wait_cycles(1);
                golden_model(alsu_obj);
                wait_cycles(1);
                check_result(alsu_obj);
                alsu_obj.sample_cg();
            end
        end

	    // Display completion message
        $display("Simulation Completed: %0d test cases executed.", (NUM_TEST_CASES / 2) + 6 * (NUM_TEST_CASES / 2));
        $display("Test Summary: Passed = %0d, Failed = %0d", pass_count, error_count);
	    $stop;
    end

    task wait_cycles(input int num_cycles);
        repeat (num_cycles) @(negedge clk);
    endtask

    task assert_reset();
        rst = 0;
        wait_cycles(1);
        rst = 1;
        wait_cycles(1);
        rst = 0;
    endtask
    
    task drive_inputs(input alsu_inputs alsu_obj);
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
    endtask

    task check_result(input alsu_inputs alsu_obj);
        local_error_count = 0;

        if (out !== alsu_obj.out) begin
            $error("[ERROR] output mismatch. Expected: %0d, Got: %0d", alsu_obj.out, out);
            local_error_count++;
        end

        if (leds !== alsu_obj.leds) begin
            $error("[ERROR] leds mismatch. Expected: %b, Got: %b", alsu_obj.leds, leds);
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

    function void golden_model(input alsu_inputs alsu_obj);
        bit invalid_red_op, invalid_opcode, invalid;

        // invalid checks
        invalid_red_op = (alsu_obj.red_op_A | alsu_obj.red_op_B) & (alsu_obj.opcode[1] | alsu_obj.opcode[2]);
        invalid_opcode = alsu_obj.opcode[1] & alsu_obj.opcode[2];
        invalid        = invalid_red_op | invalid_opcode;

        // LEDs behavior
        if (alsu_obj.rst) begin
            alsu_obj.leds = 16'h0;
        end else begin
            if (invalid) begin
                alsu_obj.leds = ~alsu_obj.leds;   // toggle like RTL
            end else begin
                alsu_obj.leds = 16'h0;
            end
        end

        if (alsu_obj.rst) begin
            alsu_obj.out = 0;
        end else begin
            if (alsu_obj.bypass_A && alsu_obj.bypass_B) begin
                alsu_obj.out = ("A" == "A") ? alsu_obj.A : alsu_obj.B;
            end else if (alsu_obj.bypass_A) begin
                alsu_obj.out = alsu_obj.A;
            end else if (alsu_obj.bypass_B) begin
                alsu_obj.out = alsu_obj.B;
            end else if (invalid) begin
                alsu_obj.out = 0;
            end else begin
                case (alsu_obj.opcode)
                    OR: begin
                        if (alsu_obj.red_op_A && alsu_obj.red_op_B) begin
                            alsu_obj.out = ("A" == "A") ? (|alsu_obj.A) : (|alsu_obj.B);
                        end else if (alsu_obj.red_op_A) begin
                            alsu_obj.out = |alsu_obj.A;
                        end else if (alsu_obj.red_op_B) begin
                            alsu_obj.out = |alsu_obj.B;
                        end else begin
                            alsu_obj.out = alsu_obj.A | alsu_obj.B;
                        end
                    end
                    XOR: begin
                        if (alsu_obj.red_op_A && alsu_obj.red_op_B) begin
                            alsu_obj.out = ("A" == "A") ? (^alsu_obj.A) : (^alsu_obj.B);
                        end else if (alsu_obj.red_op_A) begin
                            alsu_obj.out = ^alsu_obj.A;
                        end else if (alsu_obj.red_op_B) begin
                            alsu_obj.out = ^alsu_obj.B;
                        end else begin
                            alsu_obj.out = alsu_obj.A ^ alsu_obj.B;
                        end
                    end
                    ADD: begin
                        if ("ON" == "ON") begin // FULL_ADDER check
                            alsu_obj.out = alsu_obj.A + alsu_obj.B + alsu_obj.cin;
                        end else begin
                            alsu_obj.out = alsu_obj.A + alsu_obj.B;
                        end
                    end
                    MULT: alsu_obj.out = alsu_obj.A * alsu_obj.B;
                    SHIFT: begin
                        if (alsu_obj.direction) begin
                            alsu_obj.out = {out[4:0], serial_in};
                        end else begin
                            alsu_obj.out = {serial_in, out[5:1]};
                        end
                    end
                    ROTATE: begin
                        if (alsu_obj.direction) begin
                            alsu_obj.out = {out[4:0], out[5]};
                        end else begin
                            alsu_obj.out = {out[0], out[5:1]};
                        end
                    end
                    default: alsu_obj.out = 0;
                endcase
            end
        end
    endfunction

endmodule
