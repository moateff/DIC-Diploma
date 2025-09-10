module param_shift_register_tb;

    // Declare testbench signals
    reg sclr;
    reg sset;
    reg shiftin;
    reg load;
    reg [7:0] data;  // SHIFT_WIDTH = 8
    reg clock;
    reg enable;
    reg aclr;
    reg aset;
    wire shiftout;
    wire [7:0] q;

    // Instantiate the parameterized shift register
    param_shift_register #(
        .LOAD_AVALUE(2),           // LOAD_AVALUE = 2
        .LOAD_SVALUE(4),           // LOAD_SVALUE = 4
        .SHIFT_DIRECTION("LEFT"),  // SHIFT_DIRECTION = "LEFT"
        .SHIFT_WIDTH(8)            // SHIFT_WIDTH = 8
    ) uut (
        .sclr(sclr),
        .sset(sset),
        .shiftin(shiftin),
        .load(load),
        .data(data),
        .clock(clock),
        .enable(enable),
        .aclr(aclr),
        .aset(aset),
        .shiftout(shiftout),
        .q(q)
    );

    // Clock generation: 10 time unit period
    always begin
        #5 clock = ~clock; // Generate a clock with a period of 10 time units
    end

    // Task to verify expected behavior and output q
    task verify_q(input [7:0] expected_q);
        begin
            if (q == expected_q)
                $display("TEST PASSED: Expected q = %b, Actual q = %b", expected_q, q);
            else
                $display("TEST FAILED: Expected q = %b, Actual q = %b", expected_q, q);
        end
    endtask

    // Stimulus process: Generate test cases
    initial begin
        // Initialize signals
        clock = 0;
        sclr = 0;
        sset = 0;
        shiftin = 0;
        load = 0;
        data = 8'b00000000;
        enable = 1;
        aclr = 0;
        aset = 0;

        // Test 2.1: Verify Asynchronous Clear (aclr)
        aclr = 1; // Assert aclr
        aset = 0; // Deassert aset
        #10; // Wait a few time units
        verify_q(8'b00000000); // q should be cleared

        // Test 2.2: Verify Asynchronous Set (aset)
        aclr = 0; // Deassert aclr
        aset = 1; // Assert aset
        #10; // Wait a few time units
        verify_q(8'b00000010); // q should be loaded with LOAD_AVALUE (2)

        // Test 2.3: Verify Synchronous Clear (sclr)
        aclr = 0; // Deassert aclr
        aset = 0; // Deassert aset
        sclr = 1; // Assert sclr
        sset = 0; // Deassert sset
        #10; // Wait a few time units
        verify_q(8'b00000000); // q should be cleared due to sclr

        // Test 2.4: Verify Synchronous Set (sset)
        sclr = 0; // Deassert sclr
        sset = 1; // Assert sset
        #10; // Wait a few time units
        verify_q(8'b00000100); // q should be loaded with LOAD_SVALUE (4)

        // Test 2.5: Verify Load Functionality
        sclr = 0; // Deassert sclr
        sset = 0; // Deassert sset
        load = 1; // Assert load
        data = 8'b11011011; // Set input data
        #10; // Wait a few time units
        verify_q(8'b11011011); // q should be loaded with the data value

        // Test 2.6: Verify Shifting Functionality (Shift Left)
        load = 0; // Deassert load
        sclr = 0; // Deassert sclr
        sset = 0; // Deassert sset
        shiftin = 1; // Set serial shift input
        #10; // Wait for 1 clock cycle
        verify_q(8'b10110111); // Check the shifting behavior
        #10;
        verify_q(8'b01101111); // Continue checking shifting

        // Randomized tests: Generate random values for control signals
        repeat (5) begin
            #20;
            sclr = $random;
            sset = $random;
            shiftin = $random;
            load = $random;
            data = $random;
            aclr = $random;
            aset = $random;
            #10;
        end

        // End simulation
        $stop;
    end

    // Monitor the outputs to check correctness
    initial begin
        $monitor("At time %t: q = %b, shiftout = %b", $time, q, shiftout);
    end

endmodule
