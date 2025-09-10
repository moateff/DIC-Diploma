module decoder (
    input  [1:0] A,  // 2-bit input
    output [3:0] D   // 4-bit output
);
    /*
    // Conditional assignments for each output bit
    assign D[0] = (A == 2'b00) ? 1'b1 : 1'b0;
    assign D[1] = (A == 2'b01) ? 1'b1 : 1'b0;
    assign D[2] = (A == 2'b10) ? 1'b1 : 1'b0;
    assign D[3] = (A == 2'b11) ? 1'b1 : 1'b0;
    */

    // Assign output based on A[1] first, then A[0]
    assign D = (A[1] == 1'b1) ? ((A[0] == 1'b1) ? 4'b1000 : 4'b0100) :
               ((A[0] == 1'b1) ? 4'b0010 : 4'b0001);
    
endmodule
