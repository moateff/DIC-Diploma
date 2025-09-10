module dff_en_pre_tb ();
    parameter CLK_PERIOD = 10;
    reg  CLK, E, PRE_n, D;
    wire Q;

    dff_en_pre DUT (
        .CLK(CLK), 
        .E(E), 
        .PRE_n(PRE_n), 
        .D(D),
        .Q(Q)
    );

    always begin
        #(CLK_PERIOD/2) CLK = ~CLK;
    end

    task wait_cycles;
        input integer num_cycles;
        integer i;
        begin
            for (i = 0; i < num_cycles; i = i + 1) begin
                #(CLK_PERIOD);
            end
        end
    endtask
        
    task apply_reset;
        begin
            PRE_n = 1'b0;
            wait_cycles(1);      
            PRE_n = 1'b1; 
        end
    endtask

    task apply_enable;
        begin
            E = 1'b1; 
        end
    endtask

    initial begin
        CLK = 1'b0;
        PRE_n = 1'b1;
        E = 1'b0;
        D = 1'b1;
    end

    initial begin
        wait_cycles(1);
        apply_reset;
        apply_enable;
        repeat(50) begin
            D = $random;
            wait_cycles(1); 
        end
        $finish;
    end

endmodule