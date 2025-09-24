import alu_pkg::*;

module alu_tb();
    // TESTBENCH VARIABLES
    int NUM_TEST_CASES = 200;
    int error_count = 0;
    int pass_count = 0;
    
    // DUT
    byte operand1, operand2;
    bit clk, rst;
    opcode_e opcode;
    byte out;

    // GOLDEN MODEL
    byte expected_out;

    alu_seq DUT(operand1, operand2, clk, rst, opcode, out);

    Transaction tr = new();

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
            tr.clk = clk;
        end
    end
    
    initial begin
        $display("Starting ALU testbench...");
        assert_reset();
        check_result(out, 0);

        repeat (NUM_TEST_CASES) begin
            assert(tr.randomize());
            operand1 = tr.operand1;
            operand2 = tr.operand2;
            opcode = tr.opcode;
            @(negedge clk);
            expected_out = golden_model(tr);
            check_result(out, expected_out);
        end
        
        // Display completion message
        $display("Simulation Completed: %0d test cases executed.", NUM_TEST_CASES);
        $display("Test Summary: Passed = %0d, Failed = %0d", pass_count, error_count);
	    $stop;
    end
    
    task wait_cycles(input int num_cycles);
        repeat (num_cycles) @(negedge clk);
    endtask

    task assert_reset();
        wait_cycles(1);
        rst = 1;
        wait_cycles(1);
        rst = 0;
    endtask
    
    task check_result(
        input byte out,
        input byte expected_out
    );

        if (out !== expected_out) begin
            error_count++;
            $display("[FAIL] mismatch. Expected: %0d, Got: %0d", expected_out, out);
        end else begin
            pass_count++;
            $display("[PASS] Outputs match expected values.");
        end

    endtask

    function automatic byte golden_model(input Transaction tr);
        if (rst) begin
            return 0;
        end else begin
            return (tr.opcode == ADD)  ? tr.operand1 + tr.operand2 :
                (tr.opcode == SUB)  ? tr.operand1 - tr.operand2 :
                (tr.opcode == MULT) ? tr.operand1 * tr.operand2 :
                                        tr.operand1 / tr.operand2;
        end
    endfunction

endmodule