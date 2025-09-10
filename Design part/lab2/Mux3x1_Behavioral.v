module MUX3x1_Behavioral (
    input D0, D1, D2,
    input S0, S1,

    output reg Y
);
    always @(*) begin
        casex ({S1,S0})
            2'b00: Y = D0;
            2'b01: Y = D1;
            2'b1x: Y = D2;
            default: ;
        endcase
    end
    
endmodule