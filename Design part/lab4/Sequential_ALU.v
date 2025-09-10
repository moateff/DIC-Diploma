module seq_ALU (
    input  clk, rst,
    input  [3:0] A, B,
    input  [1:0] opcode,
    output [7:0] out
);  
    reg [3:0] A_r, B_r;
    reg [1:0] opcode_r;
    reg [7:0] out_w, out_r;

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            A_r <= 0;
            B_r <= 0;
            opcode_r <= 0;
            out_r <= 0;
        end else begin
            A_r <= A;
            B_r <= B;
            opcode_r <= opcode;
            out_r <= out_w;
        end
    end

    always @(A_r or B_r or opcode_r) begin
        case (opcode_r)
            2'b00: out_w = A_r + B_r;
            2'b01: out_w = A_r * B_r;
            2'b10: out_w = A_r | B_r;
            2'b11: out_w = A_r & B_r;
            default: ;
        endcase
    end

    assign out = out_r;

endmodule