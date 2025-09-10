module decimal_to_bcd_encoder (
    input  [9:0] d,     // 10-bit input (D0 to D9)
    output reg [3:0] y  // 4-bit output (Y3 to Y0)
);
    always @(*) begin
        case (d)
            10'b0000000001: y = 4'b0000; // 0
            10'b0000000010: y = 4'b0001; // 1
            10'b0000000100: y = 4'b0010; // 2
            10'b0000001000: y = 4'b0011; // 3
            10'b0000010000: y = 4'b0100; // 4
            10'b0000100000: y = 4'b0101; // 5
            10'b0001000000: y = 4'b0110; // 6
            10'b0010000000: y = 4'b0111; // 7
            10'b0100000000: y = 4'b1000; // 8
            10'b1000000000: y = 4'b1001; // 9
            default:        y = 4'b0000; // Default case (held zero)
        endcase
    end
endmodule
