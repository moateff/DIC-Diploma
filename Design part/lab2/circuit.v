module circuit (
    input [2:0] D,       // 3-bit input D
    input A, B, C, sel,  // Additional inputs
    output out, out_bar  // Outputs
);
    wire and_out, or_out, xnor_out, mux_out;

    assign and_out = D[0] & D[1];  // AND gate
    assign or_out = and_out | D[2];  // OR gate
    assign xnor_out = ~(A ^ B ^ C);  // XNOR gate

    assign mux_out = sel ? xnor_out : or_out;  // 2:1 MUX
    assign out = mux_out;  
    assign out_bar = ~mux_out;  // NOT gate

endmodule
