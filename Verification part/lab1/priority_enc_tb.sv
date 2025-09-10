module priority_enc_tb;
    parameter CLK_PERIOD = 10;
    int error_count, correct_count;
    int expected_Y, expected_valid;

    // Signals
    logic clk, rst;
    logic [3:0] D;
    logic [1:0] Y;
    logic valid;

    // Instantiate the DUT 
    priority_enc DUT (.*);

    // Clock Generation 
    always #(CLK_PERIOD/2) clk = ~clk;

    // Task to apply inputs
    task drive_input (
        input [3:0] data
    );
        D = data;
        @(negedge clk);
    endtask

    // Expected priority encoding function
    function void expected_output(
        input  [3:0] din,
        output [1:0] expected_Y, 
        output expected_valid
    );
        begin
            casex (din)
                4'b1000: begin
                    expected_Y = 2'b00;
                    expected_valid = 1'b1;
                end
                4'bx100: begin
                    expected_Y = 2'b01;
                    expected_valid = 1'b1;
                end
                4'bxx10: begin
                    expected_Y = 2'b10;
                    expected_valid = 1'b1;
                end
                4'bxxx1: begin
                    expected_Y = 2'b11;
                    expected_valid = 1'b1;
                end
                default: begin
                    expected_Y = 2'bxx;
                    expected_valid = 1'b0;
                end
            endcase
        end
    endfunction

    task check_result (
        input [1:0] expected_Y, 
        input expected_valid
    );  
        if (Y !== expected_Y || valid !== expected_valid) begin
            $display("[%0t] ERROR: Expected Y = %b, valid = %b | Got Y = %b, valid = %b | D = %b", 
                    $time, expected_Y, expected_valid, Y, valid, D);
            error_count++;
        end else begin
            correct_count++;
        end
    endtask


    task assert_reset;
        rst = 1'b1;        // Assert reset
        @(negedge clk);          
        rst = 1'b0;       
    endtask

    task wait_cycles (
        input integer num_cycles
    );            
        repeat(num_cycles) @(negedge clk);
    endtask

    // Test process
    initial begin
        initialize_inputs;
        wait_cycles(1);

        // ENCODER1
        assert_reset;
        expected_output(D, expected_Y, expected_valid);
        check_result(2'b00, expected_valid); 

        // ENCODER2
        for (int i = 0; i < 15; i++) begin
            drive_input(i);
            expected_output(i, expected_Y, expected_valid);
            check_result(expected_Y, expected_valid);  
        end

        // Finish Simulation
        $display("you got correct cases = %0d, and wrong cases = %0d", correct_count, error_count);
        $stop;
    end

    task initialize_inputs;
        clk = 0;
        rst = 0;
        D = 4'b1111;
    endtask

endmodule