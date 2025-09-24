import counter_pkg::*;

module counter_tb (counter_if.TEST c_if);
    int NUM_TEST_CASES = 500;
    
    counter_txn txn = new();

    initial begin
        $display("Starting Counter testbench...");
        assert_reset();

        repeat(NUM_TEST_CASES - 1) begin
            assert(txn.randomize());
            c_if.rst_n = txn.rst_n;
            c_if.load_n = txn.load_n;
            c_if.up_down = txn.up_down;
            c_if.ce = txn.ce;
            c_if.data_load = txn.data_load;
            @(negedge c_if.clk);
            txn.count_out = c_if.count_out;
            txn.max_count = c_if.max_count;
            txn.zero = c_if.zero;
            txn.cg.sample();
        end

        // Display completion message
        $display("Simulation Completed: %0d test cases executed.", NUM_TEST_CASES);
        $stop;
    end

    task assert_reset();
        c_if.rst_n = 1;
        @(negedge c_if.clk);
        c_if.rst_n = 0;
        @(negedge c_if.clk);
        c_if.rst_n = 1;
    endtask

endmodule
