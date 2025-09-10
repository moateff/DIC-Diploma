module Nbit_ALU_tb;
    parameter N = 4;
    reg  [N-1:0] A, B;
    reg  [1:0]   opcode;
    wire [N-1:0] result;
    reg  [N-1:0] expected_result;

    // Instantiate the ALU
    Nbit_ALU #(N) alu (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );

    // Task for checking the result
    task check_result;
        input [N-1:0] expected;
        begin
            if (result !== expected) begin
                $display("Test failed: A = %b, B = %b, opcode = %b, result = %b, Expected = %b", A, B, opcode, result, expected);
            end else begin
                $display("Test passed: A = %b, B = %b, opcode = %b, result = %b", A, B, opcode, result);
            end
        end
    endtask

    initial begin
        // Randomize inputs and check the result
        repeat (10) begin
            A = $random;
            B = $random;
            opcode = $random % 4; // Random opcode between 0 and 3

            case (opcode)
                2'b00: expected_result = A + B;    // Addition
                2'b01: expected_result = A - B;    // Subtraction
                2'b10: expected_result = A | B;    // OR
                2'b11: expected_result = A ^ B;    // XOR
            endcase

            #10; // Wait for the result

            // Call the check_result task
            check_result(expected_result);
        end

        $finish;
    end
endmodule