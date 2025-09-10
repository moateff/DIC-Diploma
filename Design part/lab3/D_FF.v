module dff (
    input wire d,       // Data input
    input wire rstn,    // Active low asynchronous reset
    input wire clk,     // Clock input
    output reg q,       // Flip-Flop output
    output wire qbar    // Complementary output (inverted q)
);
    assign qbar = ~q;       // Complementary output

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin    // Asynchronous reset (active low)
            q <= 0;         // Reset output to 0
        end else begin
            q <= d;         // On clock edge, store input d
        end
    end

endmodule
