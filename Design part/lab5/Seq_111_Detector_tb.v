`timescale 1ns / 1ps

module Seq_111_Detector_tb();

    reg clk;
    reg rst;
    reg Din;
    wire ERR;

    // Instantiate DUT
    Seq_111_Detector DUT (
        .Din(Din),
        .clk(clk),
        .rst(rst),
        .ERR(ERR)
    );

    // Clock generation (100 MHz ? 10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Apply reset
        rst = 1;
        Din = 0;
        #15;
        rst = 0;

        // Generate random serial data for 50 cycles
        repeat (50) begin
            @(posedge clk);
            Din = $random % 2;   // Random 0 or 1
        end

        // Finish simulation
        #50;
        $stop;
    end

    // Display activity in console
    initial begin
        $display("Time\tDin\tERR\tState");
        $monitor("%0t\t%b\t%b\t%b", $time, Din, ERR, DUT.crnt_state);
    end

endmodule

