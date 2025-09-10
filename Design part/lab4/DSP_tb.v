`timescale 1ns / 1ps

module DSP_tb;
    
    reg clk;
    reg rst_n;
    reg [17:0] A;
    reg [17:0] B;
    reg [47:0] C;
    reg [17:0] D;
    wire [47:0] P;
    
    // Instantiate the DSP48A1_simplified module
    DSP uut (
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .P(P)
    );
    
    // Clock Generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        A = 18'd0;
        B = 18'd0;
        C = 48'd0;
        D = 18'd0;
        
        // Apply reset
        #10 rst_n = 1;
        
        // Test Case 1: Simple Addition
        #10 A = 18'd5; B = 18'd3; C = 48'd10; D = 18'd2;
        
        // Test Case 2: Different Values
        #10 A = 18'd7; B = 18'd1; C = 48'd20; D = 18'd6;
        
        // Test Case 3: Edge Case - Maximum values
        #10 A = 18'h3FFFF; B = 18'h3FFFF; C = 48'hFFFFFFFFFFFF; D = 18'h3FFFF;
        
        // Apply Delay 
        #10 A = 18'd0;  B = 18'd0; C = 48'd0; D = 18'd0;
        #50;

        // Test Case 4: Reset Condition
        #10 rst_n = 0;
        #10 rst_n = 1;
        
        // End simulation
        #50 $stop;
    end
endmodule
