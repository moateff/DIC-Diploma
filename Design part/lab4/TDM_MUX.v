module TDM_MUX (
    input wire clk,
    input wire rst,
    input wire [1:0] in0,
    input wire [1:0] in1,
    input wire [1:0] in2,
    input wire [1:0] in3,
    output reg [1:0] out
);

    reg [1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 2'b00; // Reset to 0
        else
            counter <= counter + 2'b01; // Increment counter sequentially
    end

    always @(*) begin
        case (counter)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase
    end
endmodule
