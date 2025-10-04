import fifo_shared_pkg::*;
import fifo_transaction_pkg::*;
import fifo_coverage_pkg::*;
import fifo_scoreboard_pkg::*;

module fifo_monitor(fifo_if.MONITOR fifoif);
    
    fifo_transaction F_txn;
    fifo_coverage F_cvr;
    fifo_scoreboard F_sb;

    initial begin
        F_txn = new();
        F_cvr = new();
        F_sb = new();

        forever begin
            wait(sample_event);
            @(negedge fifoif.clk);
            F_txn.rst_n = fifoif.rst_n;
            F_txn.wr_en = fifoif.wr_en;
            F_txn.rd_en = fifoif.rd_en;
            F_txn.data_in = fifoif.data_in;
            F_txn.data_out = fifoif.data_out;
            F_txn.wr_ack = fifoif.wr_ack;
            F_txn.full = fifoif.full;
            F_txn.empty = fifoif.empty;
            F_txn.almostfull = fifoif.almostfull;
            F_txn.almostempty = fifoif.almostempty;
            F_txn.overflow = fifoif.overflow;
            F_txn.underflow = fifoif.underflow;

            fork
                F_cvr.sample_data(F_txn);
                F_sb.check_data(F_txn);
            join

            #0;

            if (test_finished) begin
                $display("Simulation Completed: %0d test cases executed.", (NUM_TEST_CASES * 3));
                $display("Test Summary: Passed = %0d, Failed = %0d", correct_count, error_count);
	            $stop;
            end
        end
    end

endmodule