////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module fifo #(parameter FIFO_WIDTH = 16, FIFO_DEPTH = 8) (fifo_if.DUT fifoif);

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		wr_ptr <= 0;
        fifoif.wr_ack <= 0; // wr_ack flag should be cleared on reset
        fifoif.overflow <= 0; // overflow flag should be cleared on reset
	end
	else if (fifoif.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= fifoif.data_in;
		fifoif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifoif.wr_ack <= 0; 
		if (fifoif.full & fifoif.wr_en)
			fifoif.overflow <= 1;
		else
			fifoif.overflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		rd_ptr <= 0;
        fifoif.underflow <= 0; // underflow flag should be cleared on reset
	end
	else if (fifoif.rd_en && count != 0) begin
		fifoif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
    else begin // underflow flag logic should be sequential 
		if (fifoif.empty & fifoif.rd_en) //
			fifoif.underflow <= 1; //
		else //
			fifoif.underflow <= 0; //
	end //
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) 
			count <= count + 1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty)
			count <= count - 1;
        else if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.empty) // unhandled case when read/write and fifo is empty
			count <= count + 1; //
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.full) // unhandled case when read/write and fifo is full
			count <= count - 1; //
	end
end

assign fifoif.full = (count == FIFO_DEPTH)? 1 : 0;
assign fifoif.empty = (count == 0)? 1 : 0;
// assign fifoif.underflow = (fifoif.empty && fifoif.rd_en)? 1 : 0; // underflow flag logic should be sequential
assign fifoif.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; // fifo is almostfull when only one location left
assign fifoif.almostempty = (count == 1)? 1 : 0;

`ifdef SIM
    always_comb begin 
        if (!fifoif.rst_n) begin
            assert_rst_n: assert final(wr_ptr == {max_fifo_addr{1'b0}} && rd_ptr == {max_fifo_addr{1'b0}} && count == {(max_fifo_addr + 1){1'b0}});
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
            (count == 0) |-> fifoif.empty;
    endproperty

    property full_p;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
            (count == FIFO_DEPTH) |-> fifoif.full;
    endproperty

    property almostfull_p;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
            (count == FIFO_DEPTH - 1) |-> fifoif.almostfull;
    endproperty

    property almostempty_p;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
            (count == 1) |-> fifoif.almostempty;
    endproperty

    property wr_ptr_wraparound_p;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
            (wr_ptr == (FIFO_DEPTH - 1) && fifoif.wr_en && !fifoif.full) |=> (wr_ptr == {max_fifo_addr{1'b0}});
    endproperty

    property rd_ptr_wraparound_p;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
            (rd_ptr == FIFO_DEPTH-1 && fifoif.rd_en && !fifoif.empty) |=> (rd_ptr == {max_fifo_addr{1'b0}});
    endproperty

    property ptr_threshold_p;
        @(posedge fifoif.clk) disable iff (!fifoif.rst_n)
            ((wr_ptr < FIFO_DEPTH) && (rd_ptr < FIFO_DEPTH) && (count <= FIFO_DEPTH));
    endproperty

    assert_wr_ack: assert property(wr_ack_p);
    assert_overflow: assert property(overflow_p);
    assert_underflow: assert property(underflow_p);
    assert_empty: assert property(empty_p);
    assert_full: assert property(full_p);
    assert_almostfull: assert property(almostfull_p);
    assert_almostempty: assert property(almostempty_p);
    assert_wr_ptr_wraparound:assert property(wr_ptr_wraparound_p);
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

`endif 

endmodule