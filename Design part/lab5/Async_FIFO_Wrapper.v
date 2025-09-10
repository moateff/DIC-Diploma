`timescale 1ns / 1ps

module Async_FIFO_Wrapper#(
    parameter FIFO_WIDTH = 16,
    parameter FIFO_DEPTH = 512
)(
    input  wire                  clk,      // 100 MHz onboard clock (W5)
    input  wire                  rst,      
    input  wire [FIFO_WIDTH-1:0] din_a,
    input  wire                  wen_a,
    input  wire                  ren_b,
    output wire [FIFO_WIDTH-1:0] dout_b,
    output wire                  full,
    output wire                  empty,
    output wire                  locked    // clock wizard locked signal
);

    // Generated clocks
    wire clk_a;   // write clock
    wire clk_b;   // read clock

    // Clock Wizard Instance
    // Configure in Vivado GUI:
    //   Input:  100 MHz
    //   Output1: 100 MHz (clk_a)
    //   Output2: 25 MHz  (clk_b)

    clk_wiz_0 u_clk_wiz (
        .clk_in1 (clk),     // input: 100 MHz onboard
        .reset   (rst),     // optional reset
        .clk_out1(clk_a),   // output clock 100 MHz
        .clk_out2(clk_b),   // output clock 25 MHz
        .locked  (locked)   // indicates stable outputs
    );

    // Async FIFO Instance
    Async_FIFO #(
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) u_async_fifo (
        .clk_a (clk_a),   // write clock
        .clk_b (clk_b),   // read clock
        .rst   (rst),     // sync reset
        .din_a (din_a),   // write data
        .wen_a (wen_a),   // write enable
        .ren_b (ren_b),   // read enable
        .dout_b(dout_b),  // read data
        .full  (full),    // fifo full
        .empty (empty)    // fifo empty
    );

endmodule

