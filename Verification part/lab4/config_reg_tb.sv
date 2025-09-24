module config_reg_tb ();
    // TESTBENCH VARIABLES
    int error_count = 0;
    int pass_count = 0;

    // DUT 
    bit clk;
    bit reset;
    bit write;
	bit [15:0] data_in;
    bit [2:0] address;
    logic [15:0] data_out;

    // TEST
    // Associative array, as a golden model for the reset values of the registers.
    bit [15:0] assert_assoc [string];

    // A user defined enumerated type that hold the values of the registers
    typedef enum { 
        ADC0_REG,
        ADC1_REG,
        TEMP_SENSOR0_REG,
        TEMP_SENSOR1_REG,
        ANALOG_TEST,
        DIGITAL_TEST,
        AMP_GAIN,
        DIGITAL_CONFIG
    } reg_t;

    // A variable from the enum. This variable will be assigned to the address connected to the DUT
    reg_t my_reg;

    config_reg DUT (clk, reset, write, data_in, address, data_out);

    initial begin
        clk = 0;
        forever begin 
            #5 clk = ~clk;
        end
    end

    initial begin
        $display("Starting CONFIG_REG testbench...");
        assert_assoc["ADC0_REG"] = 16'hFFFF;
        assert_assoc["ADC1_REG"] = 16'h0;
        assert_assoc["TEMP_SENSOR0_REG"] = 16'h0;
        assert_assoc["TEMP_SENSOR1_REG"] = 16'h0;
        assert_assoc["ANALOG_TEST"] = 16'hABCD;
        assert_assoc["DIGITAL_TEST"] = 16'h0;
        assert_assoc["AMP_GAIN"] = 16'h0;
        assert_assoc["DIGITAL_CONFIG"] = 16'h1;

        $display("Check reset values...");
        assert_reset();
        check_reset_values();

        $display("Write 16'hFFFF to each register then read...");
        write_value_then_check(16'hFFFF);

        $display("Check reset values...");
        assert_reset();
        check_reset_values();

        $display("Write walking ones to each register then read...");
        for (int i = 0; i < 16; i++) begin
            write_value_then_check(1 << i);
        end

        $display("Simulation Completed");
        $display("Test Summary: Passed = %0d, Failed = %0d", pass_count, error_count);
	    $stop;
    end

    task wait_cycles(input int num_cycles);
        repeat (num_cycles) @(negedge clk);
    endtask

    task assert_reset();
        reset = 1;
        wait_cycles(1);
        reset = 0;
    endtask

    task check16Bits(input string reg_name, input bit [15:0] expected_data, input logic [15:0] read_data);
        if (read_data !== expected_data) begin
            error_count++;
            $error("[MISMATCH] read from register %s: Expected: 0x%0h, Got: 0x%0h", reg_name, expected_data, read_data);
        end else begin
            pass_count++;
        end
    endtask

    task check_reset_values();
        for (int i = 0; i < my_reg.last + 1; i++) begin
            address = my_reg;
            wait_cycles(1);
            check16Bits(my_reg.name, assert_assoc[my_reg.name], data_out);
            my_reg = my_reg.next;
        end
    endtask

    task write_value_then_check(input bit [15:0] write_data);
        data_in = write_data;
        for (int i = 0; i < my_reg.last + 1; i++) begin
            write = 1;
            address = my_reg;
            wait_cycles(1);
            write = 0;
            wait_cycles(1);
            check16Bits(my_reg.name, write_data, data_out);
            my_reg = my_reg.next;
        end
    endtask
endmodule