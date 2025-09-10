`timescale 1ns / 1ps

module Async_FIFO_tb();

    // Parameters
    localparam FIFO_WIDTH = 16;
    localparam FIFO_DEPTH = 16;   // small for testing
    localparam ADDR_SIZE  = $clog2(FIFO_DEPTH);

    // DUT signals
    reg                     clk_a;
    reg                     clk_b;
    reg                     rst;
    reg  [FIFO_WIDTH-1:0]   din_a;
    reg                     wen_a;
    reg                     ren_b;
    wire [FIFO_WIDTH-1:0]   dout_b;
    wire                    full;
    wire                    empty;

    // Instantiate DUT
    Async_FIFO #(
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
        .ADDR_SIZE(ADDR_SIZE)
    ) DUT (
        .clk_a(clk_a),
        .clk_b(clk_b),
        .rst(rst),
        .din_a(din_a),
        .wen_a(wen_a),
        .ren_b(ren_b),
        .dout_b(dout_b),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        clk_a = 0;
        forever #5 clk_a = ~clk_a;   // 100 MHz
    end

    initial begin
        clk_b = 0;
        forever #7 clk_b = ~clk_b;   // ~71 MHz
    end

    // Stimulus
    integer i;
    initial begin
        // Init
        rst   = 1;
        wen_a = 0;
        ren_b = 0;
        din_a = 0;

        // Release reset
        #20 rst = 0;

        // Run for 50 cycles of write clock
        for (i = 0; i < 50; i = i + 1) begin
            @(posedge clk_a);

            // Randomize write
            wen_a = $random % 2;
            din_a = $random;

            // Randomize read (using read clock domain)
            @(posedge clk_b);
            ren_b = $random % 2;

            // Avoid write when full
            if (full) wen_a = 0;

            // Avoid read when empty
            if (empty) ren_b = 0;
        end

        #50 $stop;
    end

    // Monitor activity
    initial begin
        $display("Time\tclk_a\twen\tdin\tfull\tempty\tclk_b\tren\tdout");
        $monitor("%0t\t%b\t%b\t%h\t%b\t%b\t%b\t%b\t%h",
                 $time, clk_a, wen_a, din_a, full, empty, clk_b, ren_b, dout_b);
    end

endmodule

