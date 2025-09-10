`timescale 1ns / 1ps

import counter_pkg::*;

module counter_tb;
    // TESTBENCH VARIABLES
    int local_error_count = 0;
    int error_count = 0;
    int pass_count  = 0;

    // DUT
    logic clk;
    logic rst_n; 
    logic load_n; 
    logic up_down; 
    logic ce;
    logic [WIDTH - 1:0] data_load;
    logic [WIDTH - 1:0] count_out;
    logic max_count;
    logic zero;

    // GOLDEN MODEL 
    logic [WIDTH - 1:0] golden_count_out;
    logic golden_max_count;
    logic golden_zero;

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

    counter_txn txn;

    always #5 clk = ~clk;

    task wait_cycles(input int num_cycles);
        repeat (num_cycles) @(negedge clk);
    endtask

    task assert_reset();
        rst_n = 0;
    endtask

    task deassert_reset();
        rst_n = 1;
    endtask


    task golden_model();
        if (!rst_n) begin
            golden_count_out = 0;
        end else if (!load_n) begin
            golden_count_out = data_load;
        end else if (ce) begin
            if (up_down) begin
                golden_count_out = golden_count_out + 1;
            end else begin
                golden_count_out = golden_count_out - 1;
            end
        end
        golden_max_count = (golden_count_out == {WIDTH{1'b1}});
        golden_zero = (golden_count_out == 0);
    endtask

    task check_result();
        local_error_count = 0;

        if (count_out !== golden_count_out) begin
            $error("[ERROR] count_out mismatch. Expected: %0d, Got: %0d", golden_count_out, count_out);
            local_error_count++;
        end

        if (max_count !== golden_max_count) begin
            $error("[ERROR] max_count mismatch. Expected: %b, Got: %b", golden_max_count, max_count);
            local_error_count++;
        end

        if (zero !== golden_zero) begin
            $error("[ERROR] zero mismatch. Expected: %b, Got: %b", golden_zero, zero);
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


    initial begin
        $display("Starting counter testbench...");
        clk = 0;
        rst_n = 1;
        txn = new();

        // COUNTER1
        $display("\nCOUNTER1\n");
        assert_reset();
        golden_model();
        wait_cycles(1);
        deassert_reset();
        check_result();

        // COUNTER2
        $display("\nCOUNTER2\n");
        repeat (10) begin
            assert (txn.randomize(load_n, data_load));
            drive_inputs();
            golden_model();
            wait_cycles(1);
            if (~load_n) begin
                check_result();
            end
        end
        txn.reset();

        // COUNTER3 & COUNTER4
        $display("\nCOUNTER3 & COUNTER4\n");
        repeat (10) begin
            assert (txn.randomize(ce, up_down));
            drive_inputs();
            golden_model();
            wait_cycles(1);
            if (ce) begin
                check_result();
            end
        end
        txn.reset();

        // COUNTER5
        $display("\nCOUNTER5\n");
        repeat (10) begin
            assert (txn.randomize(up_down));
            drive_inputs();  
            golden_model();
            wait_cycles(1);
            check_result();
        end
        txn.reset();

        // COUNTER6 & COUNTER7
        $display("\nCOUNTER6 & COUNTER7\n");
        repeat (50) begin
            assert (txn.randomize(ce, up_down));
            drive_inputs();
            golden_model();
            wait_cycles(1);
            if (max_count) begin
                check_result();
            end
            if (zero) begin
                check_result();
            end
        end
        txn.reset();

        // COUNTER8 
        $display("\nCOUNTER8\n");    
        repeat (10) begin
            assert (txn.randomize());
            drive_inputs();
            golden_model();
            wait_cycles(1);
            check_result();
        end
        txn.reset();

        // COUNTER9
        $display("\nCOUNTER9\n");
        repeat (10) begin
            assert (txn.randomize(load_n, ce));
            drive_inputs();
            golden_model();
            wait_cycles(1);
            if (~load_n & ce) begin
                check_result();
            end
        end

        // Display completion message
        $display("Simulation Completed: %0d test cases executed.", pass_count + error_count);
        $display("Test Summary: Passed = %0d, Failed = %0d", pass_count, error_count);
        $stop;
    end
    
    task drive_inputs();
        rst_n     = txn.rst_n;
        load_n    = txn.load_n;
        ce        = txn.ce;
        up_down   = txn.up_down;
        data_load = txn.data_load;
    endtask

endmodule
