`timescale 1ns / 1ps

import counter_pkg::*;

module counter_tb;
    // TESTBENCH VARIABLES
    int NUM_TEST_CASES = 500;
    int local_error_count = 0;
    int error_count = 0;
    int pass_count  = 0;

    // DUT
    bit clk;
    bit rst_n; 
    bit load_n; 
    bit up_down; 
    bit ce;
    bit [WIDTH - 1:0] data_load;
    logic [WIDTH - 1:0] count_out;
    logic max_count;
    logic zero;

    counter #(.WIDTH(WIDTH)) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .load_n(load_n),
        .up_down(up_down),
        .ce(ce),
        .data_load(data_load),
        .count_out(count_out),
        .max_count(max_count),
        .zero(zero)
    );

    counter_txn txn = new();

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
            txn.clk = clk;
        end
    end

    initial begin
        $display("Starting Counter testbench...");
        assert_reset();

        repeat(NUM_TEST_CASES - 1) begin
            assert(txn.randomize());
            drive_inputs(txn);
            wait_cycles(1);
            golden_model(txn);
            check_result(txn);
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
        rst_n = 1;
        wait_cycles(1);
        rst_n = 0;
        wait_cycles(1);
        rst_n = 1;
    endtask
    
    task drive_inputs(input counter_txn txn);
        rst_n = txn.rst_n;
        load_n = txn.load_n;
        up_down = txn.up_down;
        ce = txn.ce;
        data_load = txn.data_load;
    endtask

    task check_result(input counter_txn txn);
        local_error_count = 0;

        if (count_out !== txn.count_out) begin
            $error("[ERROR] count_out mismatch. Expected: %0d, Got: %0d", txn.count_out, count_out);
            local_error_count++;
        end

        if (max_count !== txn.max_count) begin
            $error("[ERROR] max_count mismatch. Expected: %b, Got: %b", txn.max_count, max_count);
            local_error_count++;
        end

        if (zero !== txn.zero) begin
            $error("[ERROR] zero mismatch. Expected: %b, Got: %b", txn.zero, zero);
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

    task golden_model(input counter_txn txn);
        if (!txn.rst_n) begin
            txn.count_out = 0;
        end else if (!txn.load_n) begin
            txn.count_out = txn.data_load;
        end else if (txn.ce) begin
            if (txn.up_down) begin
                txn.count_out++;
            end else begin
                txn.count_out--;
            end
        end
        txn.max_count = (txn.count_out == {WIDTH{1'b1}});
        txn.zero = (txn.count_out == 0);
    endtask

endmodule
