`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 02:28:50 PM
// Design Name: 
// Module Name: RAM
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


module RAM 
#(
    parameter MEM_DEPTH = 1024,
    parameter MEM_WIDTH = 16,
    parameter ADDR_SIZE = 10
) (
    input clk,
    input rst,
    
    input blk_select,
    input wr_en,
    input rd_en,
    
    input [ADDR_SIZE-1:0] addr_wr,
    input [ADDR_SIZE-1:0] addr_rd,
    
    input      [MEM_WIDTH-1:0] din,
    output reg [MEM_WIDTH-1:0] dout
);

    reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    
    always @(posedge clk) begin
        if (rst) begin
            dout <= 0;
        end else if (blk_select) begin
            if (wr_en) begin
                mem[addr_wr] <= din;
            end
            if (rd_en) begin 
                dout <= mem[addr_rd];
            end
        end
    end
    
endmodule
