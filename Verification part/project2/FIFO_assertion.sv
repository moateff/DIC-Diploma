import fifo_shared_pkg::*;

module fifo_sva (fifo_if.DUT fifoif);

always_comb begin
    if (!fifoif.rst_n) begin
        assert final ((fifoif.empty == 1) && (fifoif.full == 0) && 
                (fifoif.almostfull == 0) && (fifoif.almostempty == 0) && 
                (fifoif.overflow == 0) && (fifoif.underflow == 0) &&
                (fifoif.wr_ack == 0));
    end
end

always_comb begin 
    if (!fifoif.rst_n) begin
        assert final(DUT.wr_ptr == 0 && DUT.rd_ptr == 0 && DUT.count == 0);
    end 
end

property wr_ack_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (fifoif.wr_en && !fifoif.full) |=> fifoif.wr_ack;
endproperty

property overflow_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (fifoif.wr_en && fifoif.full) |=> fifoif.overflow;
endproperty

property underflow_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (fifoif.rd_en && fifoif.empty) |=> fifoif.underflow;
endproperty

property empty_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (DUT.count == 0) |-> fifoif.empty;
endproperty

property full_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (DUT.count == FIFO_DEPTH) |-> fifoif.full;
endproperty

property almostfull_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (DUT.count == FIFO_DEPTH - 1) |-> fifoif.almostfull;
endproperty

property almostempty_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (DUT.count == 1) |-> fifoif.almostempty;
endproperty

property wr_ptr_wraparound_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (DUT.wr_ptr == (FIFO_DEPTH - 1) && fifoif.wr_en && !fifoif.full) |=> (DUT.wr_ptr == 0);
endproperty

property rd_ptr_wraparound_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        (DUT.rd_ptr == FIFO_DEPTH-1 && fifoif.rd_en && !fifoif.empty) |=> (DUT.rd_ptr == 0);
endproperty

property ptr_threshold_p;
    @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
        ((DUT.wr_ptr < FIFO_DEPTH) && (DUT.rd_ptr < FIFO_DEPTH) && (DUT.count <= FIFO_DEPTH));
endproperty

assert_wr_ack: assert property(wr_ack_p);
assert_overflow: assert property(overflow_p);
assert_underflow: assert property(underflow_p);
assert_empty: assert property(empty_p);
assert_full: assert property(full_p);
assert_almostfull: assert property(almostfull_p);
assert_almostempty: assert property(almostempty_p);
assert_wr_ptr_wraparound: assert property(wr_ptr_wraparound_p);
assert_rd_ptr_wraparound: assert property(rd_ptr_wraparound_p);
assert_ptr_threshold: assert property(ptr_threshold_p);

cover_wr_ack: cover property(wr_ack_p);
cover_overflow: cover property(overflow_p);
cover_underflow: cover property(underflow_p);
cover_empty: cover property(empty_p);
cover_full: cover property(full_p);
cover_almostfull: cover property(almostfull_p);
cover_almostempty: cover property(almostempty_p);
cover_wr_ptr_wraparound: cover property(wr_ptr_wraparound_p);
cover_rd_ptr_wraparound: cover property(rd_ptr_wraparound_p);
cover_ptr_threshold: cover property(ptr_threshold_p);

endmodule