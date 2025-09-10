`timescale 1ns / 1ps

module Async_FIFO #(
    parameter FIFO_WIDTH = 16,
    parameter FIFO_DEPTH = 512,
    parameter ADDR_SIZE  = $clog2(FIFO_DEPTH)
)(
    input  wire                  clk_a,   // write clock
    input  wire                  clk_b,   // read clock
    input  wire                  rst,     // sync reset

    // Write port
    input  wire [FIFO_WIDTH-1:0] din_a,
    input  wire                  wen_a,

    // Read port
    input  wire                  ren_b,
    output reg  [FIFO_WIDTH-1:0] dout_b,

    // Status
    output wire                  full,
    output wire                  empty
);

    // Internal memory
    reg [FIFO_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // Write and read pointers
    reg [ADDR_SIZE:0] wr_ptr;  // one bit wider for full detection
    reg [ADDR_SIZE:0] rd_ptr;

    // Write logic
    always @(posedge clk_a) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wen_a && !full) begin
            mem[wr_ptr[ADDR_SIZE-1:0]] <= din_a;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read logic
    always @(posedge clk_b) begin
        if (rst) begin
            rd_ptr  <= 0;
            dout_b  <= {FIFO_WIDTH{1'b0}};
        end else if (ren_b && !empty) begin
            dout_b <= mem[rd_ptr[ADDR_SIZE-1:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Status flags
    assign empty = (wr_ptr == rd_ptr);
    assign full  = ( (wr_ptr[ADDR_SIZE]     != rd_ptr[ADDR_SIZE]) &&
                     (wr_ptr[ADDR_SIZE-1:0] == rd_ptr[ADDR_SIZE-1:0]) );

endmodule
