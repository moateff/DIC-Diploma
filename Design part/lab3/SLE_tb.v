`timescale 1ns/1ps

module SLE_tb;
    // Testbench Signals
    reg D, CLK, EN, ALn, ADn, SLn, SD, LAT;
    wire Q;

    // Instantiate the DUT (Device Under Test)
    SLE uut (
        .D(D),
        .CLK(CLK),
        .EN(EN),
        .ALn(ALn),
        .ADn(ADn),
        .SLn(SLn),
        .SD(SD),
        .LAT(LAT),
        .Q(Q)
    );

    // Clock Generation (50% Duty Cycle)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; // Toggle clock every 5ns
    end

    // Test Sequence
    initial begin
        // Step 1: Activate ALn (Set to 0)
        ALn = 0;
        ADn = $random;  // Random asynchronous data
        #10;
        $display("TEST: ALn Activated | Expected Q = %b, Actual Q = %b", ADn, Q);
        
        // Step 2: Deactivate ALn (Set to 1)
        ALn = 1;
        #10;

        // Step 3: Flip-Flop Mode (LAT = 0)
        LAT = 0;
        repeat (10) begin
            {D, EN, SLn, SD} = $random; // Randomize inputs
            #10;
            $display("Flip-Flop Mode | D = %b, EN = %b, SLn = %b, SD = %b, Q = %b", D, EN, SLn, SD, Q);
        end

        // Step 4: Latch Mode (LAT = 1)
        LAT = 1;
        repeat (10) begin
            {D, EN, SLn, SD} = $random; // Randomize inputs
            #10;
            $display("Latch Mode | D = %b, EN = %b, SLn = %b, SD = %b, Q = %b", D, EN, SLn, SD, Q);
        end

        $finish;
    end
endmodule
