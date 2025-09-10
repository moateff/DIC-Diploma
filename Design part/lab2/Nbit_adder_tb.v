module Nbit_adder_tb;
    parameter N = 4; // Example with 4 bits
    reg [N-1:0] A, B;
    wire [N-1:0] C;
    reg [N-1:0] expected_result;

    // Instantiate the adder
    Nbit_adder #(N) adder (
        .A(A),
        .B(B),
        .C(C)
    );

    initial begin
        // Randomize inputs and check the result
        repeat (10) begin
            A = $random;
            B = $random;
            expected_result = A + B;

            #10;
            check_output;
        end

        $finish;
    end

    // Task to check output
    task check_output;
        if (C !== expected_result) 
            $display("Test failed: A = %b, B = %b, C = %b, Expected = %b", A, B, C, expected_result);
        else 
            $display("Test passed: A = %b, B = %b, C = %b", A, B, C);
    endtask

endmodule