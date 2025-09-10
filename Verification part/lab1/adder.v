module adder (
    input clk, reset,
    input signed [3:0] A, B,
    output reg signed [4:0] C
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            C <= 'b0;
        end else begin
            C <= A + B;
        end
    end
    
endmodule
