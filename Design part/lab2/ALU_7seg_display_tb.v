module ALU_7seg_display_tb;
    reg  [3:0] A, B;
    reg  [1:0] opcode;
    reg        enable;
    wire [6:0] seg;
    reg  [6:0] expected_seg;

    // Instantiate the ALU with 7-segment display
    ALU_7seg_display display (
        .A(A),
        .B(B),
        .opcode(opcode),
        .enable(enable),
        .seg(seg)
    );

    // Task for checking the result
    task check_result;
        input [6:0] expected;
        begin
            if (seg !== expected) begin
                $display("Test failed: A = %b, B = %b, opcode = %b, enable = %b, seg = %b, Expected = %b", A, B, opcode, enable, seg, expected);
            end else begin
                $display("Test passed: A = %b, B = %b, opcode = %b, enable = %b, seg = %b", A, B, opcode, enable, seg);
            end
        end
    endtask

    initial begin
        // Test vectors for all digits with enable = 1
        enable = 1;
        A = 4'h0; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1111110; #10; check_result(expected_seg); // 0
        A = 4'h1; B = 4'h0; opcode = 2'b00; expected_seg = 7'b0110000; #10; check_result(expected_seg); // 1
        A = 4'h2; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1101101; #10; check_result(expected_seg); // 2
        A = 4'h3; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1111001; #10; check_result(expected_seg); // 3
        A = 4'h4; B = 4'h0; opcode = 2'b00; expected_seg = 7'b0110011; #10; check_result(expected_seg); // 4
        A = 4'h5; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1011011; #10; check_result(expected_seg); // 5
        A = 4'h6; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1011111; #10; check_result(expected_seg); // 6
        A = 4'h7; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1110000; #10; check_result(expected_seg); // 7
        A = 4'h8; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1111111; #10; check_result(expected_seg); // 8
        A = 4'h9; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1111011; #10; check_result(expected_seg); // 9
        A = 4'hA; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1110111; #10; check_result(expected_seg); // A
        A = 4'hB; B = 4'h0; opcode = 2'b00; expected_seg = 7'b0011111; #10; check_result(expected_seg); // b
        A = 4'hC; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1001110; #10; check_result(expected_seg); // C
        A = 4'hD; B = 4'h0; opcode = 2'b00; expected_seg = 7'b0111101; #10; check_result(expected_seg); // d
        A = 4'hE; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1001111; #10; check_result(expected_seg); // E
        A = 4'hF; B = 4'h0; opcode = 2'b00; expected_seg = 7'b1000111; #10; check_result(expected_seg); // F

        // Test vector with enable = 0
        enable = 0;
        A = 4'h0; B = 4'h0; opcode = 2'b00; expected_seg = 7'b0000000; #10; check_result(expected_seg); // Display off

        $finish;
    end

endmodule