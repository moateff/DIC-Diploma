module D_latch_tb;
    reg D, G, CLR;
    wire Q;
    
    // Instantiate the data latch
    D_latch uut (
        .D(D),
        .G(G),
        .CLR(CLR),
        .Q(Q)
    );
    
    // Testbench logic
    initial begin
        // Randomized test sequence
        repeat (50) begin
            D = $random;
            G = $random;
            CLR = $random;
            #1; // Delay to avoid treating G as a clock
            $display("Time=%0t | CLR=%b, G=%b, D=%b | Q=%b", $time, CLR, G, D, Q);
        end
        
        // End simulation
        $finish;
    end
    
endmodule
