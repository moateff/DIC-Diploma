`timescale 1ns / 1ps

module circuit_tb;

    reg [2:0] D;
    reg A, B, C, sel;
    wire out, out_bar;

    // Instantiate the module
    circuit uut (
        .D(D),
        .A(A),
        .B(B),
        .C(C),
        .sel(sel),
        .out(out),
        .out_bar(out_bar)
    );

    initial begin

        // Initialize inputs
        D = 3'b000;
        A = 0;
        B = 0;
        C = 0;
        sel = 0;

        #10; // Wait 10 time units before applying test cases

        // Apply randomized test cases
        repeat (10) begin
            D = $random;
            A = $random;
            B = $random;
            C = $random;
            sel = $random;
            #10;
        end

        $finish;
    end

endmodule
