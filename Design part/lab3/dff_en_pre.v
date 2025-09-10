module dff_en_pre (
    input  CLK, E, PRE_n, D,
    output reg Q
);
    
    always @ (posedge CLK or negedge PRE_n) begin
        if (~PRE_n) begin
            Q <= 1'b1;
        end else if (E) begin
            Q <= D;
        end
    end
endmodule
