module param_ff 
#(
    parameter FF_TYPE = "DFF"  // Parameter to select flip-flop type: "DFF" or "TFF"
)(
    input wire d,     // Data or toggle input
    input wire rstn,  // Active low reset
    input wire clk,   // Clock input
    output reg q,     // Output
    output wire qbar  // Complement of the output
);

    // qbar is always the complement of q
    assign qbar = ~q;

    // Always block triggered on the rising edge of clk or falling edge of rstn
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            // If reset is active (low), set q to 0
            q <= 0;
        end else begin
            if (FF_TYPE == "DFF") begin
                // D Flip-Flop behavior: q follows d
                q <= d;
            end else if (FF_TYPE == "TFF") begin
                // T Flip-Flop behavior: q toggles if d (toggle input) is 1
                q <= q ^ d;
            end
        end
    end

endmodule
/*
    generate
        if (FF_TYPE == "DFF") begin : dff_inst
            dff dff_module (
                .d(d),
                .rstn(rstn),
                .clk(clk),
                .q(q),
                .qbar(qbar)
            );
        end else if (FF_TYPE == "TFF") begin : tff_inst
            tff tff_module (
                .t(d),      // 'd' acts as 't' in T Flip-Flop mode
                .rstn(rstn),
                .clk(clk),
                .q(q),
                .qbar(qbar)
            );
        end
    endgenerate
*/
