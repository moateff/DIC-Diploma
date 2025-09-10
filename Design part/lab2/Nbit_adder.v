module Nbit_adder #(parameter N = 1) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [N-1:0] C
);
    assign C = A + B; // Dataflow modeling
endmodule