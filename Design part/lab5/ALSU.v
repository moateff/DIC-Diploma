`timescale 1ns / 1ps

module ALSU #(
    parameter INPUT_PRIORITY = "A", // "A" or "B"
    parameter FULL_ADDER     = "ON" // "ON" or "OFF"
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        cin,
    input  wire        red_op_A,
    input  wire        red_op_B,
    input  wire        bypass_A,
    input  wire        bypass_B,
    input  wire        direction,
    input  wire        serial_in,
    input  wire [2:0]  opcode,
    input  wire [2:0]  A,
    input  wire [2:0]  B,

    output reg  [15:0] leds,
    output reg  [5:0]  out
);

    // Registered inputs
    reg cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg;
    reg direction_reg, serial_in_reg;
    reg [2:0] opcode_reg, A_reg, B_reg;

    // IP outputs
    wire [3:0] out_add;   // adder output (3-bit + carry)
    wire [5:0] out_mult;  // multiplier output

    // Invalid operation detection
    wire invalid_red_op, invalid_opcode, invalid;
    assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
    assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
    assign invalid        = invalid_red_op | invalid_opcode;

    // Pipeline inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cin_reg        <= 0;
            red_op_B_reg   <= 0;
            red_op_A_reg   <= 0;
            bypass_B_reg   <= 0;
            bypass_A_reg   <= 0;
            direction_reg  <= 0;
            serial_in_reg  <= 0;
            opcode_reg     <= 0;
            A_reg          <= 0;
            B_reg          <= 0;
        end else begin
            cin_reg        <= cin;
            red_op_B_reg   <= red_op_B;
            red_op_A_reg   <= red_op_A;
            bypass_B_reg   <= bypass_B;
            bypass_A_reg   <= bypass_A;
            direction_reg  <= direction;
            serial_in_reg  <= serial_in;
            opcode_reg     <= opcode;
            A_reg          <= A;
            B_reg          <= B;
        end
    end

    // LEDs blink if invalid
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            leds <= 0;
        end else begin
            if (invalid)
                leds <= ~leds;
            else
                leds <= 0;
        end
    end

    // Generate block for adder depending on FULL_ADDER
    generate
        if (FULL_ADDER == "ON") begin : ADDER_FULL
            c_addsub_0 a1 (
                .A    (A_reg),     // input wire [2:0]
                .B    (B_reg),     // input wire [2:0]
                .C_IN (cin_reg),   // input wire
                .S    (out_add)    // output wire [3:0]
            );
        end else begin : ADDER_NO_CIN
            c_addsub_0 a1 (
                .A    (A_reg),     // input wire [2:0]
                .B    (B_reg),     // input wire [2:0]
                .C_IN (1'b0),      // force carry-in = 0
                .S    (out_add)    // output wire [3:0]
            );
        end
    endgenerate

    // Multiplier IP
    mult_gen_1 m1 (
        .A (A_reg),  // input wire [2:0]
        .B (B_reg),  // input wire [2:0]
        .P (out_mult) // output wire [5:0]
    );

    // ALSU output logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
        end else begin
            if (bypass_A_reg && bypass_B_reg) begin
                out <= (INPUT_PRIORITY == "A") ? A_reg : B_reg;
            end else if (bypass_A_reg) begin
                out <= A_reg;
            end else if (bypass_B_reg) begin
                out <= B_reg;
            end else if (invalid) begin
                out <= 0;
            end else begin
                case (opcode_reg)
                    3'h0: begin // AND / reduction
                        if (red_op_A_reg && red_op_B_reg)
                            out <= (INPUT_PRIORITY == "A") ? &A_reg : &B_reg;
                        else if (red_op_A_reg)
                            out <= &A_reg;
                        else if (red_op_B_reg)
                            out <= &B_reg;
                        else
                            out <= A_reg & B_reg;
                    end

                    3'h1: begin // XOR / reduction
                        if (red_op_A_reg && red_op_B_reg)
                            out <= (INPUT_PRIORITY == "A") ? ^A_reg : ^B_reg;
                        else if (red_op_A_reg)
                            out <= ^A_reg;
                        else if (red_op_B_reg)
                            out <= ^B_reg;
                        else
                            out <= A_reg ^ B_reg;
                    end

                    3'h2: out <= out_add;   // Use IP adder
                    3'h3: out <= out_mult;  // Use IP multiplier

                    3'h4: begin // Shift with serial input
                        if (direction_reg)
                            out <= {out[4:0], serial_in_reg};
                        else
                            out <= {serial_in_reg, out[5:1]};
                    end

                    3'h5: begin // Rotate
                        if (direction_reg)
                            out <= {out[4:0], out[5]};
                        else
                            out <= {out[0], out[5:1]};
                    end

                    default: out <= 0;
                endcase
            end
        end
    end

endmodule

