module priority_encoder (
    input [3:0] x,  // 4-bit input
    output reg [1:0] y  // 2-bit output
);
    always @(*) begin

        //Switch Cases
        casex (x)
            4'b1xxx: y = 2'b11;  // Highest priority: x3 = 1
            4'b01xx: y = 2'b10;  // Second priority: x2 = 1
            4'b001x: y = 2'b01;  // Third priority: x1 = 1
            default: y = 2'b00; 
        endcase

        /*
        //If-else
        if (x[3] == 1'b1) y = 2'b11;
        else if (x[2] == 1'b1) y = 2'b10;
        else if (x[1] == 1'b1) y = 2'b01;
        else  y = 2'b00;
        */
        
    end
endmodule
