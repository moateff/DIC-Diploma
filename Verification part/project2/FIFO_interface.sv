import fifo_shared_pkg::*;

interface fifo_if (clk);
    input bit clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [FIFO_WIDTH-1:0] data_in;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack;
    logic full;
    logic empty; 
    logic almostfull; 
    logic almostempty; 
    logic overflow;
    logic underflow;

    modport DUT (
        input clk, rst_n, wr_en, rd_en, data_in,
        output data_out, wr_ack, full, empty, almostfull, almostempty, overflow, underflow
    );

    modport TEST (
        input clk, data_out, wr_ack, full, empty, almostfull, almostempty, overflow, underflow,
        output rst_n, wr_en, rd_en, data_in
    );
endinterface : fifo_if