`timescale 1ns / 1ps

module Gray_Counter(
    input  wire clk,
    input  wire rst,      // active high async reset
    output reg [1:0] y    // 2-bit Gray output
);

    // FSM state encoding
    localparam A = 2'b00; 
    localparam B = 2'b01; 
    localparam C = 2'b11; 
    localparam D = 2'b10;

    // State registers
    reg [1:0] crnt_state, nxt_state;

    // Sequential: State update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crnt_state <= A;   // Reset to state A (00)
        end else begin
            crnt_state <= nxt_state;
        end
    end

    // Combinational: Next-state logic
    always @(*) begin
        case (crnt_state)
            A: nxt_state = B;  // 00 -> 01
            B: nxt_state = C;  // 01 -> 11
            C: nxt_state = D;  // 11 -> 10
            D: nxt_state = A;  // 10 -> 00
            default: nxt_state = A;
        endcase
    end

    // Moore Output: depends only on crnt_state
    always @(*) begin
        case (crnt_state)
            A: y = 2'b00;
            B: y = 2'b01;
            C: y = 2'b11;
            D: y = 2'b10;
            default: y = 2'b00;
        endcase
    end

endmodule

