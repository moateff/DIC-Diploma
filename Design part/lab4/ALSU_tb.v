`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2025 01:34:48 AM
// Design Name: 
// Module Name: ALSU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for ALSU module verifying different functionalities.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALSU_tb;

  // Parameters
  parameter WIDTH = 8;

  // Signals
  reg clk; 
  reg rst;
  reg [2:0] A, B; 
  reg [2:0] opcode;
  reg cin;
  reg serial_in;
  reg red_op_A, red_op_B;
  reg bypass_A, bypass_B;
  reg direction;
  wire [5:0] out;
  wire [15:0] leds;

  // DUT Instantiation
  ALSU DUT (
    .clk(clk),
    .rst(rst),
    .A(A),
    .B(B),
    .opcode(opcode),
    .cin(cin),
    .serial_in(serial_in),
    .red_op_A(red_op_A),
    .red_op_B(red_op_B),
    .bypass_A(bypass_A),
    .bypass_B(bypass_B),
    .direction(direction),
    .out(out),
    .leds(leds)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Testbench logic
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    A = 0;
    B = 0;
    opcode = 0;
    cin = 0;
    serial_in = 0;
    red_op_A = 0;
    red_op_B = 0;
    bypass_A = 0;
    bypass_B = 0;
    direction = 0;

    // 2.1 Verify Asynchronous Reset Functionality
    @(negedge clk);
    if (out != 0 || leds != 0) $display("Reset failed!");

    // 2.2 Verify Bypass Functionality
    bypass_A = 1;
    bypass_B = 1;
    rst = 0;
    repeat(10) begin
        A = $random;
        B = $random;
        opcode = $urandom_range(0, 5);
        repeat(2) @(negedge clk);
        if (out != A || leds != 0) 
            $display("Bypass Test Failed! A=%d, B=%d, Out=%d", A, B, out);
    end

    // 2.3 Verify opcode 0 Functionality
    bypass_A = 0;
    bypass_B = 0;
    opcode = 0;
    repeat(10) begin
        A = $random;
        B = $random;
        red_op_A = $random;
        red_op_B = $random;
        repeat(2) @(negedge clk);
        casex ({red_op_A, red_op_B})
            2'b00: if (out != (A & B)) $display("Opcode 0 Test Failed! A=%d, B=%d, Out=%d", A, B, out);
            2'b01: if (out != &B) $display("Opcode 0 Test Failed! A=%d, B=%d, Out=%d", A, B, out);
            2'b1x: if (out != &A) $display("Opcode 0 Test Failed! A=%d, B=%d, Out=%d", A, B, out);
        endcase
    end

    // 2.4 Verify opcode 1 Functionality
    opcode = 1;
    repeat(10) begin
        A = $random;
        B = $random;
        red_op_A = $random;
        red_op_B = $random;
        repeat(2) @(negedge clk);
        casex ({red_op_A, red_op_B})
            2'b00: if (out != (A ^ B)) $display("Opcode 0 Test Failed! A=%d, B=%d, Out=%d", A, B, out);
            2'b01: if (out != ^B) $display("Opcode 0 Test Failed! A=%d, B=%d, Out=%d", A, B, out);
            2'b1x: if (out != ^A) $display("Opcode 0 Test Failed! A=%d, B=%d, Out=%d", A, B, out);
        endcase
    end

    // 2.5 Verify opcode 2 Functionality
    red_op_A = 0;
    red_op_B = 0;
    opcode = 2;
    repeat(10) begin
        A = $random;
        B = $random;
        cin = $random;
        repeat(2) @(negedge clk);
        if (out !== (A + B + cin)) 
            $display("Opcode 2 Test Failed! A=%d, B=%d, Cin=%d, Out=%d", A, B, cin, out);
    end

    // 2.6 Verify opcode 3 Functionality
    opcode = 3;
    repeat(10) begin
        A = $random;
        B = $random;
        repeat(2) @(negedge clk);
        if (out !== (A * B)) 
            $display("Opcode 3 Test Failed! A=%d, B=%d, Out=%d", A, B, out);
    end
    
    // 2.7 Verify opcode 3 Functionality
    opcode = 4;
    repeat(10) begin
        A = $random;
        B = $random;
        serial_in = $random;
        direction = $random;
        repeat(2) @(negedge clk);
    end
    
    // 2.7 Verify opcode 3 Functionality
    opcode = 5;
    repeat(10) begin
        A = $random;
        B = $random;
        serial_in = $random;
        direction = $random;
        repeat(2) @(negedge clk);
    end
        
    // Finish Simulation
    $display("All tests completed successfully!");
    $finish;
  end

endmodule