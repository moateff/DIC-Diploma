`timescale 1ns / 1ps

module decimal_to_bcd_encoder_tb;

    reg [9:0] d;
    wire [3:0] y;
    reg [3:0] expected_y;

    // Instantiate the module
    decimal_to_bcd_encoder uut (
        .d(d),
        .y(y)
    );

    initial begin

        // Test cases
        d = 10'b0000000001; expected_y = 4'b0000; #10; check_output(); // 0
        d = 10'b0000000010; expected_y = 4'b0001; #10; check_output(); // 1
        d = 10'b0000000100; expected_y = 4'b0010; #10; check_output(); // 2
        d = 10'b0000001000; expected_y = 4'b0011; #10; check_output(); // 3
        d = 10'b0000010000; expected_y = 4'b0100; #10; check_output(); // 4
        d = 10'b0000100000; expected_y = 4'b0101; #10; check_output(); // 5
        d = 10'b0001000000; expected_y = 4'b0110; #10; check_output(); // 6
        d = 10'b0010000000; expected_y = 4'b0111; #10; check_output(); // 7
        d = 10'b0100000000; expected_y = 4'b1000; #10; check_output(); // 8
        d = 10'b1000000000; expected_y = 4'b1001; #10; check_output(); // 9

        // Invalid inputs (should return 0000)
        d = 10'b0000000000; expected_y = 4'b0000; #10; check_output();
        d = 10'b1111111111; expected_y = 4'b0000; #10; check_output();
        d = 10'b0000000011; expected_y = 4'b0000; #10; check_output();
        
        // Randomized tests
        repeat (5) begin
            d = 1 << ($random % 10); // Generate random valid input
            casex (d)
                10'b0000000001: expected_y = 4'b0000;
                10'b0000000010: expected_y = 4'b0001;
                10'b0000000100: expected_y = 4'b0010;
                10'b0000001000: expected_y = 4'b0011;
                10'b0000010000: expected_y = 4'b0100;
                10'b0000100000: expected_y = 4'b0101;
                10'b0001000000: expected_y = 4'b0110;
                10'b0010000000: expected_y = 4'b0111;
                10'b0100000000: expected_y = 4'b1000;
                10'b1000000000: expected_y = 4'b1001;
                default: expected_y = 4'b0000;
            endcase
            #10;
            check_output();
        end

        $stop;
    end

    // Task to check output
    task check_output;
        if (y !== expected_y) 
            $display("Test Failed: d = %b, Expected y = %b, Got y = %b", d, expected_y, y);
        else 
            $display("Test Passed: d = %b, y = %b", d, y);
    endtask

endmodule
