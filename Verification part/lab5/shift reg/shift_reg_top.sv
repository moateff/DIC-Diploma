////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import shift_reg_test_pkg::*;
`include "uvm_macros.svh"

module shift_reg_top();

  bit clk;

  initial begin
    forever begin
      #1 clk = ~clk;
    end
  end

  shift_reg_if shift_regif(clk);

  shift_reg DUT(
    clk,
    shift_regif.reset,
    shift_regif.serial_in,
    shift_regif.direction,
    shift_regif.mode,
    shift_regif.datain,
    shift_regif.dataout
  );

  initial begin
    uvm_config_db#(virtual shift_reg_if)::set(null, "uvm_test_top", "VIF", shift_regif);
    run_test("shift_reg_test");
  end
endmodule