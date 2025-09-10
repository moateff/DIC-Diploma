module Nbit_ALU #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    input [1:0] opcode,
    output reg [N-1:0] result
);
    wire [N-1:0] add_result;

    // Instantiate the adder for addition
    Nbit_adder #(N) adder (
        .A(A),
        .B(B),
        .C(add_result)
    );

    always @(*) begin
        case (opcode)
            2'b00: result = add_result;    // Addition
            2'b01: result = A - B;         // Subtraction
            2'b10: result = A | B;         // OR
            2'b11: result = A ^ B;         // XOR
            default: result = {N{1'b0}};   // Default case
        endcase
    end
endmodule