import fifo_shared_pkg::*;
import fifo_transaction_pkg::*;

module fifo_tb(fifo_if.TEST fifoif);

    fifo_transaction F_txn;

    initial begin
        $display("Starting FIFO testbench...");
        test_finished = 0;
        F_txn = new();

        $display("Reset Asserted...");
        reset_sequence(F_txn);
        $display("Reset Deasserted...");

        $display("Starting write only sequence...");
        write_only_sequence(F_txn);

        $display("Starting read only sequence...");
        read_only_sequence(F_txn);

        $display("Starting read/write sequence...");
        read_write_sequence(F_txn);
        test_finished = 1;
    end

    task drive_inputs(fifo_transaction F_txn);
        fifoif.rst_n = F_txn.rst_n;
        fifoif.wr_en = F_txn.wr_en;
        fifoif.rd_en = F_txn.rd_en;
        fifoif.data_in = F_txn.data_in;
        ->> sample_event;
        @(negedge fifoif.clk);
    endtask

    task reset_sequence(fifo_transaction F_txn);
        F_txn.rst_n = 0;
        F_txn.wr_en = 0;
        F_txn.rd_en = 0;
        F_txn.data_in = 0;
        drive_inputs(F_txn);
    endtask

    task write_only_sequence(fifo_transaction F_txn);
        F_txn = new(.rd_dist(30), .wr_dist(70));
        repeat(NUM_TEST_CASES) begin
            assert(F_txn.randomize());
            drive_inputs(F_txn);
        end
    endtask

    task read_only_sequence(fifo_transaction F_txn);
        F_txn = new(.rd_dist(70), .wr_dist(30));
        repeat(NUM_TEST_CASES) begin
            assert(F_txn.randomize());
            drive_inputs(F_txn);
        end
    endtask

    task read_write_sequence(fifo_transaction F_txn);
        F_txn = new(.rd_dist(50), .wr_dist(50));
        repeat(NUM_TEST_CASES) begin
            assert(F_txn.randomize());
            drive_inputs(F_txn);
        end
    endtask

endmodule