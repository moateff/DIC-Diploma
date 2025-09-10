module ripple_counter (
    input wire clk,    // Clock input
    input wire rstn,   // Active low reset
    output wire [3:0] out // 4-bit output
);

    // Internal signals for the flip-flop outputs
    wire [3:0] q;

    // Generate block to instantiate D flip-flops
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_ff
            dff ff (
                .d(~q[i]),  // Toggle input
                .rstn(rstn),
                .clk(i == 0 ? clk : q[i-1]), // First flip-flop, clocked by the main clock
                .q(q[i]),
                .qbar()
            );
        end
    endgenerate

    // Assign the outputs
    assign out = q;

endmodule