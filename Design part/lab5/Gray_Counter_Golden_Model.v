`timescale 1ns / 1ps

module Gray_Counter_Golden_Model(
    input  wire clk,
    input  wire rst,           // active high async reset
    output reg [1:0] gray_out  // 2-bit Gray output
);

    reg [1:0] binary_count;

    // Sequential binary counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            binary_count <= 2'b00;       // reset binary counter
        end else begin
            binary_count <= binary_count + 1'b1; // increment
        end
    end

    // Binary-to-Gray conversion
    always @(*) begin
        gray_out[1] = binary_count[1];                 // MSB same
        gray_out[0] = binary_count[1] ^ binary_count[0]; // XOR for LSB
    end

endmodule

