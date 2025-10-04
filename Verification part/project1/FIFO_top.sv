module fifo_top();

    bit clk;
    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end

    fifo_if fifoif (clk);
    fifo DUT (fifoif);
    fifo_tb TEST (fifoif);
    fifo_monitor MONITOR (fifoif);
    
`ifdef SIM
    always_comb begin
        if (!fifoif.rst_n) begin
            assert final ((fifoif.empty == 1) && (fifoif.full == 0) && 
                    (fifoif.almostfull == 0) && (fifoif.almostempty == 0) && 
                    (fifoif.overflow == 0) && (fifoif.underflow == 0) &&
                    (fifoif.wr_ack == 0));
        end
    end
`endif

endmodule