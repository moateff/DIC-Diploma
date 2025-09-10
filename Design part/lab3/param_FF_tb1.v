`timescale 1ns/1ps

module param_ff_tb1;

    reg d, clk, rstn;
    wire q_param, qbar_param;
    wire q_golden, qbar_golden;

    // Instantiate parameterized Flip-Flop with DFF behavior
    param_ff #(.FF_TYPE("DFF")) uut (
        .d(d),
        .rstn(rstn),
        .clk(clk),
        .q(q_param),
        .qbar(qbar_param)
    );

    // Instantiate golden model (DFF)
    dff golden_model (
        .d(d),
        .rstn(rstn),
        .clk(clk),
        .q(q_golden),
        .qbar(qbar_golden)
    );

    // Clock Generation
    always #5 clk = ~clk;  // Generate a 10ns clock period

    // Task to check correctness
    task check_output;
        if (q_param !== q_golden || qbar_param !== qbar_golden)
            $display("Mismatch at time %0t: q_param=%b, q_golden=%b", $time, q_param, q_golden);
        else
            $display("Pass at time %0t: q_param=%b, q_golden=%b", $time, q_param, q_golden);
    endtask

    initial begin
        // Initialize signals
        clk = 0;
        rstn = 0;
        d = 0;

        // Apply Reset
        #10 rstn = 1;

        // Apply test vectors using repeat loop
        repeat (20) begin
            #10 d = $random;
            #10 check_output;
        end

        // Apply reset and observe outputs
        #10 rstn = 0;
        #10 rstn = 1;
        check_output;

        // Finish simulation
        #50 $finish;
    end

endmodule
