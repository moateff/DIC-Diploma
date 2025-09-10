`timescale 1ns / 1ps

module DSP
#(
    parameter OPERATION = "ADD" // OPERATION: take 2 values either "ADD" or "SUBTRACT", Default value "ADD"
)(
    input wire clk,
    input wire rst_n,
    input wire [17:0] A,
    input wire [17:0] B,
    input wire [47:0] C,
    input wire [17:0] D,
    output reg [47:0] P
);
    
    localparam ADD = 1'b0, SUBTRACT = 1'b1;
    localparam OP_MODE = (OPERATION == "SUBTRACT") ? SUBTRACT : ADD;

    reg [17:0] first_add_sub_result;
    reg [35:0] multiplier_out;
    reg [47:0] second_add_sub_result;
    reg [17:0] A_r, A_rr;
    reg [17:0] B_r;
    reg [17:0] D_r;
    reg [47:0] C_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A_r <= 18'b0; 
            A_rr <= 18'b0;
            B_r <= 18'b0;
            D_r <= 18'b0;
            C_r <= 48'b0;

            first_add_sub_result <= 18'd0;
            multiplier_out <= 36'd0;
            second_add_sub_result <= 48'b0;
            P <= 48'b0;

        end else begin

            // register input ports
            A_r <= A; 
            A_rr <= A_r;
            B_r <= B;
            D_r <= D;
            C_r <= C;

            // Addition or Subtraction operation for first stage
            case (OP_MODE)
                ADD: first_add_sub_result <= D_r + B_r;
                SUBTRACT: first_add_sub_result <= D_r - B_r;
            endcase

            // Multiplication operation
            multiplier_out <= A_rr * first_add_sub_result;

            // Addition or Subtraction operation for second stage
            case (OP_MODE)
                ADD: second_add_sub_result <= multiplier_out + C_r;
                SUBTRACT: second_add_sub_result <= multiplier_out - C_r;
            endcase
            
            // Pipeline stage
            P <= second_add_sub_result;
        end
    end
    
endmodule
