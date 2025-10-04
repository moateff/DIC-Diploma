package fifo_scoreboard_pkg;
import fifo_shared_pkg::*;
import fifo_transaction_pkg::*;

class fifo_scoreboard #(parameter FIFO_WIDTH = 16, FIFO_DEPTH = 8);
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref;
    logic full_ref;
    logic empty_ref; 
    logic almostfull_ref; 
    logic almostempty_ref; 
    logic overflow_ref;
    logic underflow_ref;

    bit [FIFO_WIDTH-1:0] fifo_ref [$]; 

    function void check_data(fifo_transaction F_txn);
        reference_model(F_txn);

        if ((data_out_ref !== F_txn.data_out) || (wr_ack_ref !== F_txn.wr_ack) || (full_ref !== F_txn.full) || 
            (empty_ref !== F_txn.empty) || (almostfull_ref !== F_txn.almostfull) || (almostempty_ref !== F_txn.almostempty) ||
            (overflow_ref !== F_txn.overflow) || (underflow_ref !== F_txn.underflow)) begin
            
            $display("time: %0t Comparsion failed, Transaction received from DUT: %s While the reference data_out_ref = 0x%0h, wr_ack_ref = %0b, full_ref = %0b, empty_ref = %0b, almostfull_ref = %0b, almostempty_ref = %0b, overflow_ref = %0b, underflow_ref = %0b", 
                $time, F_txn.convert2string(), data_out_ref, wr_ack_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, overflow_ref, underflow_ref);
            
            error_count++;
        end else begin
            $display("time: %0t Comparsion successed, Transaction received from DUT: %s ", $time, F_txn.convert2string());

            correct_count++;
        end
    endfunction

    function void reference_model(fifo_transaction F_txn);
        if (!F_txn.rst_n) begin
            fifo_ref.delete();

            wr_ack_ref = 0;
            overflow_ref = 0;
            underflow_ref = 0;
        end else begin
            if (F_txn.rd_en) begin
                if (!empty_ref) begin
                    data_out_ref = fifo_ref.pop_front();
                end else begin
                    underflow_ref = 1;
                end
            end else begin
                underflow_ref = 0;
            end

            if (F_txn.wr_en) begin
                if (!full_ref) begin
                    fifo_ref.push_back(F_txn.data_in);
                    wr_ack_ref = 1;
                end else begin
                    wr_ack_ref = 0;
                    overflow_ref = 1;
                end
            end else begin
                wr_ack_ref = 0;
                overflow_ref = 0;
            end
        end

        full_ref = (fifo_ref.size() == FIFO_DEPTH);
        empty_ref = (fifo_ref.size() == 0);
        almostfull_ref = (fifo_ref.size() == FIFO_DEPTH - 1);
        almostempty_ref = (fifo_ref.size() == 1);
    endfunction
endclass : fifo_scoreboard

endpackage : fifo_scoreboard_pkg
