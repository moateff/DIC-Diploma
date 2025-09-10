`timescale 1ns / 1ps

module Seq_111_Detector(
    input  wire clk,
    input  wire rst,   // async active-high reset
    input  wire Din,   // serial data input (1 bit per clock)
    output reg  ERR    // error flag: high when "111" detected
);

    // State encoding
    localparam START     = 3'b000;
    localparam D0_IS_1   = 3'b001; // first 1 seen
    localparam D1_IS_1   = 3'b010; // second consecutive 1 seen
    localparam D0_NOT_1  = 3'b011; // first bit was 0
    localparam D1_NOT_1  = 3'b100; // second bit was 0

    reg [2:0] crnt_state, nxt_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crnt_state <= START;
        end else begin
            crnt_state <= nxt_state;
        end
    end

    // Next-state logic + output (Mealy)
    always @(*) begin
        // defaults
        nxt_state = crnt_state;
        ERR = 1'b0;

        case (crnt_state)
            START: begin
                if (Din) begin
                    nxt_state = D0_IS_1;
                end else begin
                    nxt_state = D0_NOT_1;
                end
            end

            D0_IS_1: begin
                if (Din) begin
                    nxt_state = D1_IS_1;
                end else begin
                    nxt_state = D1_NOT_1;
                end
            end

            D0_NOT_1: begin
                // regardless of Din, move on
                nxt_state = D1_NOT_1;
            end

            D1_IS_1: begin
                // regardless of Din, back to start
                nxt_state = START; 
                if (Din) begin
                    // detected 111
                    ERR = 1'b1;
                end 
            end

            D1_NOT_1: begin
                // regardless of Din, back to start
                nxt_state = START;
            end

            default: begin
                nxt_state = START;
            end
        endcase
    end

endmodule


