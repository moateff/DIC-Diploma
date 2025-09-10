module adder_tb;
    parameter CLK_PERIOD = 10;
    localparam MAXPOS = 7, ZERO = 0, MAXNEG = -8;
    integer rand_A = 0, rand_B = 0;

    logic clk, reset;
    logic signed [3:0] A, B;
    logic signed [4:0] C;

    int error_count, correct_count;

    adder DUT (.*);

    function signed [4:0] adder_fun (
        input signed [3:0] in1, in2
    );
        return in1 + in2;
    endfunction

    task drive_inputs (
        input signed [3:0] in1, in2
    );  
        A = in1;
        B = in2;
    endtask

    task check_result (
        input signed [4:0] expected_result
    );  
        wait_cycles(1);
        if (C != expected_result) begin
            $display("expected output = %d, you got output = %d, A = %d, B = %d", expected_result, C, A, B);
            error_count++;
        end else begin
            correct_count++;
        end
    endtask

	task assert_reset;
        reset = 1'b1; 
        check_result(ZERO);     
        reset = 1'b0;
    endtask

	task wait_cycles (
        input integer num_cycles
    );            
        repeat(num_cycles) @(negedge clk);
    endtask

    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        initialize_inputs;

        // ADDER_1
        assert_reset;

        // ADDER_2
        drive_inputs(MAXNEG, MAXNEG);
        check_result(adder_fun(MAXNEG, MAXNEG));

        // ADDER_3   
        drive_inputs(MAXNEG, ZERO);
        check_result(adder_fun(MAXNEG, ZERO));

        // ADDER_4  
        drive_inputs(MAXNEG, MAXPOS);
        check_result(adder_fun(MAXNEG, MAXPOS));

        // ADDER_5
        drive_inputs(ZERO, ZERO);
        check_result(adder_fun(ZERO, ZERO));

        // ADDER_6   
        drive_inputs(ZERO, MAXPOS);
        check_result(adder_fun(ZERO, MAXPOS));

        // ADDER_7 
        drive_inputs(ZERO, MAXNEG);
        check_result(adder_fun(ZERO, MAXNEG));

        // ADDER_8
        drive_inputs(MAXPOS, MAXPOS);
        check_result(adder_fun(MAXPOS, MAXPOS));

        // ADDER_9  
        drive_inputs(MAXPOS, ZERO);
        check_result(adder_fun(MAXPOS, ZERO));

        // ADDER_10  
        drive_inputs(MAXPOS, MAXNEG);
        check_result(adder_fun(MAXPOS, MAXNEG));

        // ADDER_11
        repeat(50) begin
            rand_A = $random; 
            rand_B = $random;
            drive_inputs(rand_A, rand_B);
            check_result(adder_fun(rand_A, rand_B));
        end

        // ADDER_12
        assert_reset;

        $display("you got correct cases = %0d, and wrong cases = %0d", correct_count, error_count);
        $stop;
    end

    task initialize_inputs;
        clk = 0;
        reset = 0;
        A = 0;
        B = 0;
        error_count = 0; 
        correct_count = 0;
    endtask

endmodule