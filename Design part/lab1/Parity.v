module even_parity_generator (
    input  [7:0] A,              // 8-bit input data
    output [8:0] out_with_parity // 9-bit output (A + parity bit)
);
    // Calculate even parity bit using XOR reduction operator
    wire parity_bit;
    assign parity_bit = ~^A; // XOR reduction, then complement for even parity

    // Concatenate parity bit with input A
    assign out_with_parity = {A, parity_bit};

endmodule
