module comparator (
    input [3:0] A, B,       // 4-bit inputs A and B
    output A_greaterthan_B,  // Output high if A > B
    output A_equals_B,       // Output high if A == B
    output A_lessthan_B      // Output high if A < B
);

    // Using conditional operator
    assign A_greaterthan_B = (A > B) ? 1'b1 : 1'b0;
    assign A_equals_B = (A == B) ? 1'b1 : 1'b0;
    assign A_lessthan_B = (A < B) ? 1'b1 : 1'b0;

endmodule
