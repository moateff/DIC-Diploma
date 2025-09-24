import uvm_pkg::*;
import alsu_test_pkg::*;
`include "uvm_macros.svh"

module alsu_tb;
    // Clock generation
    bit clk;
    initial begin
        forever begin
            #1 clk = ~clk;
        end
    end
    
    // Instantiate the interface
    alsu_if alsuif(clk);

    // Instantiate the DUT
    ALSU DUT (
        .clk(clk),
        .rst(alsuif.rst),
        .cin(alsuif.cin),
        .red_op_A(alsuif.red_op_A),
        .red_op_B(alsuif.red_op_B),
        .bypass_A(alsuif.bypass_A),
        .bypass_B(alsuif.bypass_B),
        .direction(alsuif.direction),
        .serial_in(alsuif.serial_in),
        .opcode(alsuif.opcode),
        .A(alsuif.A),
        .B(alsuif.B),
        .leds(alsuif.leds),
        .out(alsuif.out)
    );

    // Run the test
    initial begin
        uvm_config_db #(virtual alsu_if)::set(null, "uvm_test_top", "ALSU_IF", alsuif);
        run_test("alsu_test");
    end

endmodule