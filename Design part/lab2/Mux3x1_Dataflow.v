module MUX3x1_Dataflow (
    input D0, D1, D2,
    input S0, S1,

    output Y
);
    assign Y = (S1 == 1'b1) ? D2 : ((S0 == 1'b1) ? D1 : D0);
    
endmodule