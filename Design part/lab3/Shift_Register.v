module param_shift_register #(
    parameter LOAD_AVALUE = 1,
    parameter LOAD_SVALUE = 1,
    parameter SHIFT_WIDTH = 8,
    parameter SHIFT_DIRECTION = "LEFT" // "LEFT" or "RIGHT"
)(
    input wire sclr,          // Synchronous clear
    input wire sset,          // Synchronous set
    input wire shiftin,       // Serial shift data input
    input wire load,          // Synchronous parallel load
    input wire [SHIFT_WIDTH-1:0] data, // Data input
    input wire clock,         // Clock input
    input wire enable,        // Clock enable
    input wire aclr,          // Asynchronous clear
    input wire aset,          // Asynchronous set
    output reg shiftout,      // Serial shift data output
    output reg [SHIFT_WIDTH-1:0] q // Data output
);

always @(posedge clock or posedge aclr or posedge aset) begin
    if (aclr) begin
        q <= 0;
    end else if (aset) begin
        q <= LOAD_AVALUE;
    end else if (enable) begin
        if (sclr) begin
            q <= 0;
        end else if (sset) begin
            q <= LOAD_SVALUE;
        end else if (load) begin
            q <= data;
        end else begin
            if (SHIFT_DIRECTION == "LEFT") begin
                shiftout <= q[SHIFT_WIDTH-1];  // shiftout gets the leftmost bit of q
                q <= {q[SHIFT_WIDTH-2:0], shiftin};  // Shift left and append shiftin to the rightmost bit
            end else if (SHIFT_DIRECTION == "RIGHT") begin
                shiftout <= q[0];  // shiftout gets the rightmost bit of q
                q <= {shiftin, q[SHIFT_WIDTH-1:1]};  // Shift right and append shiftin to the leftmost bit
            end
        end
    end
end


endmodule