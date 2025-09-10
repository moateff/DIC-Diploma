`timescale 1ns / 1ps

module Gray_Counter_tb();

    // Testbench signals
    reg clk;
    reg rst;
    wire [1:0] gray_fsm;     // DUT output
    wire [1:0] gray_golden;  // Golden model output

    // Instantiate FSM-based Gray counter (DUT)
    Gray_Counter dut (
        .clk(clk),
        .rst(rst),
        .y(gray_fsm)
    );

    // Instantiate Binary-to-Gray counter (Golden model)
    Gray_Counter_Golden_Model golden (
        .clk(clk),
        .rst(rst),
        .gray_out(gray_golden)
    );

    // Clock generation: 100 MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Apply reset
        rst = 1;
        #12;
        rst = 0;

        // Run for some cycles
        #200;

        $stop;
    end

    // Monitor outputs
    initial begin
        $display("Time\tFSM_Out\tGolden_Out\tMatch");
        $monitor("%0t\t%b\t%b\t%b", 
                 $time, gray_fsm, gray_golden, 
                 (gray_fsm == gray_golden));
    end

endmodule

