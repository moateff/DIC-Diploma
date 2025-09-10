`timescale 1ns / 1ps

module Single_Port_Sync_RAM #(
    parameter MEM_WIDTH      = 16,
    parameter MEM_DEPTH      = 1024,
    parameter ADDR_SIZE      = $clog2(MEM_DEPTH),
    parameter ADDR_PIPELINE  = "FALSE",  // "TRUE" or "FALSE"
    parameter DOUT_PIPELINE  = "TRUE",   // "TRUE" or "FALSE"
    parameter PARITY_ENABLE  = 1
)(
    input  wire                     clk,
    input  wire                     rst,        // synchronous active high reset
    input  wire                     wr_en,      // write enable
    input  wire                     rd_en,      // read enable
    input  wire                     blk_select, // chip enable
    input  wire [ADDR_SIZE-1:0]     addr,       // input address
    input  wire [MEM_WIDTH-1:0]     din,        // data input
    input  wire                     addr_en,    // enable for pipelined address
    input  wire                     dout_en,    // enable for pipelined data out
    output reg  [MEM_WIDTH-1:0]     dout,       // data output
    output wire                     parity_out  // even parity of dout
);

    // Memory array
    reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Address pipeline register
    reg [ADDR_SIZE-1:0] addr_reg;
    wire [ADDR_SIZE-1:0] eff_addr;

    generate
        if (ADDR_PIPELINE == "TRUE") begin
            always @(posedge clk) begin
                if (rst) begin
                    addr_reg <= {ADDR_SIZE{1'b0}};
                end else if (addr_en) begin
                    addr_reg <= addr;
                end
            end
            assign eff_addr = addr_reg;
        end else begin
            assign eff_addr = addr;
        end
    endgenerate

    // RAM write operation
    always @(posedge clk) begin
        if (blk_select && wr_en) begin
            mem[eff_addr] <= din;
        end
    end

    // Read data (direct or pipelined)
    reg [MEM_WIDTH-1:0] dout_reg;

    generate
        if (DOUT_PIPELINE == "TRUE") begin
            always @(posedge clk) begin
                if (rst) begin
                    dout_reg <= {MEM_WIDTH{1'b0}};
                end else if (blk_select && rd_en && dout_en) begin
                    dout_reg <= mem[eff_addr];
                end
            end
            always @(*) begin
                if (blk_select && rd_en) begin
                    dout = dout_reg;
                end else begin
                    dout = {MEM_WIDTH{1'b0}};
                end
            end
        end else begin
            always @(*) begin
                if (blk_select && rd_en) begin
                    dout = mem[eff_addr];
                end else begin
                    dout = {MEM_WIDTH{1'b0}};
                end
            end
        end
    endgenerate

    // Even parity output
    generate
        if (PARITY_ENABLE == 1) begin
            assign parity_out = (blk_select && rd_en) ? ^dout : 1'b0;
        end else begin
            assign parity_out = 1'b0;
        end
    endgenerate

endmodule


