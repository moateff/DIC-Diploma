module ripple_counter_tb;

    // Declare testbench signals
    reg clk;
    reg rstn;
    wire [3:0] out;

    // Instantiate the 4-bit ripple counter
    ripple_counter uut (
        .clk(clk),
        .rstn(rstn),
        .out(out)
    );

    // Clock generation: 10 time unit period
    always begin
        #5 clk = ~clk; // Generate a clock with a period of 10 time units
    end

    // Stimulus process: Generate randomized reset and check the output
    initial begin
        // Initialize signals
        clk = 0;
        rstn = 0;

        // Apply reset
        #10 rstn = 1; // Assert reset after 10 time units

        // Randomize and test the counter's behavior
        #10 rstn = 0; // De-assert reset

        // Wait for a few clock cycles and then check the output
        #40;

        // Randomize the reset and observe the ripple counter
        repeat (10) begin
            #20 rstn = $random; // Randomize reset signal
            #10; // Wait for a clock cycle
        end

        // End simulation after 200 time units
        #200;
        $stop;
    end

    // Monitor the outputs to check correctness
    initial begin
        $monitor("At time %t: out = %b", $time, out);
    end

endmodule
