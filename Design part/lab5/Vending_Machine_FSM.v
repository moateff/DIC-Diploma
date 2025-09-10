`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 04:43:58 PM
// Design Name: 
// Module Name: Vending_Machine_FSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Vending_Machine_FSM(
    input clk,
    input reset,
    
    input doller,
    input quarter,
    
    output reg dispense,
    output reg change
);
    
    localparam [1:0] WAIT = 2'b00,
                     Q_25 = 2'b01,
                     Q_50 = 2'b1x;
                     
    reg [1:0] state_crnt, state_nxt;
    
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            state_crnt <= WAIT;
        end else begin
            state_crnt <= state_nxt;
        end
    end
    
    always @(*) begin
        state_nxt = state_crnt;
        dispense = 0;
        change = 0;
        
        case(state_crnt)
            WAIT: begin
                if (doller) begin
                    dispense = 1;
                    change = 1;
                end else if (quarter) begin
                    state_nxt = Q_25;
                end
            end
            Q_25: begin
                if (quarter) begin
                    state_nxt = Q_50;
                end
            end
            Q_50: begin
                if (quarter) begin
                    state_nxt = WAIT;
                    dispense = 1;
                end
            end
            default: state_nxt = WAIT;
        endcase
    end
endmodule
