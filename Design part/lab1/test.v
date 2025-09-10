module circuit(
    input  A, B, C, D, E, F, sel,  // 7 inputs
    output out, out_bar            // 2 outputs
);
    // Intermediate signals for the AND1 and XNOR1 gates
    wire AND1_out, XNOR1_out;

    // AND1 gate
    assign AND1_out = A & B & C;

    // XNOR1 gate
    assign XNOR1_out = ~(D ^ E ^ F);

    // MUX1 
    assign out = sel ? XNOR1_out : AND1_out;

    // NOT1 gate
    assign out_bar = ~out;

endmodule
