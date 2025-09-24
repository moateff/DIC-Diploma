`timescale 1ns/1ps

module ram_tb ();
    // TESTBENCH VARIABLES
    int TESTS = 100;
    int error_count = 0;
    int pass_count = 0;

    // DUT
    bit clk;
    bit write;
    bit read;
    bit [7:0] data_in;
    bit [15:0] address;
    logic [8:0] data_out;

    // GOLDEN MODLE
    // stores random addresses
    bit [15:0] address_array []; 

    // stores corresponding random data values
    bit [7:0] data_to_write_array [];

    // stores expected data, indexed by address
    bit [8:0] data_read_expect_assoc [int];

    // stores the actual data read from the RAM
    logic [7:0] data_read_queue [$];

    my_mem DUT (clk, write, read, data_in, address, data_out);

    initial begin
        clk = 0;
        forever begin 
            #5 clk = ~clk;
        end
    end

    initial begin
        write = 0;
        read = 0;
        address_array = new[TESTS];
        data_to_write_array = new[TESTS];

        // Data preparation
        stimulus_gen();
        golden_model();

        // Write Operations
        $display("Starting RAM testbench...");
        write = 1;
        read = 0;
        for (int i = 0; i < TESTS; i++) begin
            address = address_array[i];
            data_in = data_to_write_array[i];
            wait_cycles(1);
        end

        // Read and Self-Checking
        write = 0;
        read = 1;
        for (int i = 0; i < TESTS; i++) begin
            address = address_array[i];
            wait_cycles(1);
            check9Bits(address);
            data_read_queue.push_back(data_out);
        end
        
        // Test Completion and Reporting
        write = 0;
        read = 0;
        $display("Elements in data_read_queue are:");
        while (data_read_queue.size) begin
            $displayh(data_read_queue.pop_front());
        end

        // Display completion message
        $display("Simulation Completed: %0d test cases executed.", TESTS);
        $display("Test Summary: Passed = %0d, Failed = %0d", pass_count, error_count);
        $stop;
    end

    task wait_cycles(input int num_cycles);
        repeat (num_cycles) @(negedge clk);
    endtask

    task check9Bits(input [15:0] address);
        if (data_read_expect_assoc[address] !== data_out) begin
            error_count++;
            $error("[ERROR] data_out mismatch. Expected: 0x%0h, Got: 0x%0h", data_read_expect_assoc[address], data_out);
        end else begin
            pass_count++;
        end
    endtask

    task stimulus_gen();
        for (int i = 0; i < TESTS; i++) begin
            address_array[i] = $random;
            data_to_write_array[i] = $random;
        end
    endtask

    task golden_model();
        for (int i = 0; i < TESTS; i++) begin
            data_read_expect_assoc[address_array[i]] = {^data_to_write_array[i], data_to_write_array[i]};
        end
    endtask

endmodule
