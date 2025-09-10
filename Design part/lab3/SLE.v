module SLE (
    input wire D,      // Data input
    input wire CLK,    // Clock input
    input wire EN,     // Enable
    input wire ALn,    // Asynchronous Load (Active Low)
    input wire ADn,    // Asynchronous Data (Active Low)
    input wire SLn,    // Synchronous Load (Active Low)
    input wire SD,     // Synchronous Data
    input wire LAT,    // Latch Enable
    output reg Q       // Output
);

    // Always block for asynchronous operations (Asynchronous Load)
    always @(posedge CLK or negedge ALn) begin
        if (!ALn) begin
            Q <= ADn;  // Asynchronous load when ALn is low
        end 
        else if (EN) begin
            if (!SLn) begin
                Q <= SD;  // Synchronous load when SLn is low
            end 
            else if (!LAT) begin
                Q <= D;  // Flip-Flop Mode (LAT=0)
            end
        end
    end

    // Always block for latch behavior (LAT=1)
    always @(*) begin
        if (LAT) begin
            Q = D;  // Latch Mode (Transparent when LAT=1)
        end
    end

endmodule
