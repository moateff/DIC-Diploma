////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
import fifo_shared_pkg::*;

module fifo (fifo_if.DUT fifoif);

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
		if (/*fifoif.full &*/ fifoif.wr_en)
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
		if (/*fifoif.empty &*/ fifoif.rd_en) //
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

endmodule