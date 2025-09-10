module adder (
    input  [3:0] A,  // 4-bit input A
    input  [3:0] B,  // 4-bit input B
    output [3:0] C   // 4-bit output C
);
    // Sum the inputs and assign only the lower 4 bits to C
    assign C = A + B;

endmodule
