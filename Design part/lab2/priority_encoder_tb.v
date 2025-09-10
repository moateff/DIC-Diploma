`timescale 1ns / 1ps

module priority_encoder_tb;

    reg [3:0] x;
    wire [1:0] y;
    reg [1:0] expected_y;

    // Instantiate the module
    priority_encoder uut (
        .x(x),
        .y(y)
    );

    initial begin

        // Randomized test cases
        repeat (10) begin
            x = $random;
            casex (x)
                4'b1xxx: expected_y = 2'b11;
                4'b01xx: expected_y = 2'b10;
                4'b001x: expected_y = 2'b01;
                default: expected_y = 2'b00;
            endcase
            #10;
            check_output();
        end
        $finish;
    end

    // Task to check output
    task check_output;
        if (y !== expected_y) 
            $display("Test Failed: x = %b, Expected y = %b, Got y = %b", x, expected_y, y);
        else 
            $display("Test Passed: x = %b, y = %b", x, y);
    endtask

endmodule
