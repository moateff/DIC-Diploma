import uvm_pkg::*;
import fifo_test_pkg::*;
`include "uvm_macros.svh"

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
    bind fifo fifo_sva ASSERT (fifoif);    

    initial begin
        uvm_config_db #(virtual fifo_if)::set(null, "uvm_test_top", "FIFO_VIF", fifoif);
        run_test("fifo_test");
    end
    
endmodule