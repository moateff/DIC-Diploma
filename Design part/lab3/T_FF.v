module tff (
    input wire t,        // Toggle input
    input wire clk,      // Clock input
    input wire rstn,     // Active low asynchronous reset
    output reg q,        // Output
    output wire qbar     // Complementary output
);
    assign qbar = ~q;

    always @(posedge clk or negedge rstn) begin
        if (!rstn)       // Active low reset
            q <= 0;
        else if (t)      // Toggle output when t = 1
            q <= ~q;
    end
    
endmodule
