module D_latch (
    input wire D,   // Data Input
    input wire G,   // Enable (Gate)
    input wire CLR, // Active Low Clear
    output reg Q    // Output
);
    always @(*) begin
        if (!CLR) begin     // Active low clear
            Q = 0;
        end else if (G) begin   // When G is high, latch follows D
            Q = D;
        end
        // When G is low, Q retains its value (latch behavior)
    end
endmodule
