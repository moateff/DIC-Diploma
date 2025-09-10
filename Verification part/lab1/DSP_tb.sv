module DSP_tb;
    parameter CLK_PERIOD = 10;
    
    int error_count, correct_count;
    logic [17:0] A_temp, B_temp, D_temp;
    logic [47:0] C_temp;

    // Signals
    logic clk, rst_n;
    logic [17:0] A, B, D;
    logic [47:0] C;
    logic [47:0] P;  // Output from DSP

    // Instantiate the DUT (DSP module)
    DSP #(.OPERATION("ADD")) DUT (.*);

    // Clock Generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Task to drive inputs
    task drive_input (
        input [17:0] in_A, 
        input [17:0] in_B, 
        input [47:0] in_C, 
        input [17:0] in_D
    );  
        A = in_A; B = in_B; C = in_C; D = in_D;
        @(negedge clk);
    endtask

    // Function to compute expected result
    function [47:0] dsp_function (
        input [17:0] A, 
        input [17:0] B, 
        input [47:0] C, 
        input [17:0] D
    );
        dsp_function = (DUT.OPERATION == "ADD") ? (A * (D + B) + C) :
                       (DUT.OPERATION == "SUBTRACT") ? (A * (D - B) - C) : 0;
    endfunction


    // Task to check the result
    task check_result (
        input [47:0] expected_result
    );          
        if (P == expected_result) begin
            correct_count++;
        end else begin
            $display("Error: Expected = %d, Got = %d | A = %d, B = %d, C = %d, D = %d", 
                    expected_result, P, A, B, C, D);
            error_count++;
        end
    endtask

    // Task for reset assertion
    task assert_reset;
        rst_n = 1'b0; // Active-low reset
        @(negedge clk);
        rst_n = 1'b1;
    endtask

    // Task to wait for cycles
    task wait_cycles (
        input integer num_cycles
    );            
        repeat(num_cycles) @(negedge clk);
    endtask

    initial begin
        initialize_inputs;
        wait_cycles(1);

        // DSP1
        assert_reset;
        check_result(48'b0);

        // DSP2
        repeat(200) begin
            A_temp = $random;
            B_temp = $random;
            C_temp = $random;
            D_temp = $random;
            drive_input(A_temp, B_temp, C_temp, D_temp);
            wait_cycles(4);
            check_result(dsp_function(A_temp, B_temp, C_temp, D_temp));
        end

        $display("you got correct cases = %0d, and wrong cases = %0d", correct_count, error_count);
        $stop;
    end

    task initialize_inputs;
        clk = 0;
        rst_n = 1;
        A = 18'b0;
        B = 18'b0;
        C = 48'b0;
        D = 18'b0;
    endtask

endmodule
