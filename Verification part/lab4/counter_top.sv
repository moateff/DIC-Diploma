`timescale 1ns / 1ps

module counter_top();
    bit clk;
    
    initial begin
        forever #5 clk = ~clk;
    end

    counter_if c_if(clk);
    counter DUT(c_if);
    counter_tb TEST(c_if);
    bind counter counter_sva ASSERT(c_if);
endmodule