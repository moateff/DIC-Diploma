package alsu_driver_pkg;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
import alsu_shared_pkg::*;
`include "uvm_macros.svh"

class alsu_driver extends uvm_driver #(alsu_seq_item);
    `uvm_component_utils(alsu_driver)

    virtual alsu_if alsu_vif;
    alsu_seq_item seq_item;

    function new(string name = "alsu_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = alsu_seq_item::type_id::create("seq_item");
            seq_item_port.get_next_item(seq_item);
            alsu_vif.rst = seq_item.rst;
            alsu_vif.A = seq_item.A;
            alsu_vif.B = seq_item.B;
            alsu_vif.opcode = opcode_e'(seq_item.opcode);
            alsu_vif.cin = seq_item.cin;
            alsu_vif.red_op_A = seq_item.red_op_A;
            alsu_vif.red_op_B = seq_item.red_op_B;
            alsu_vif.bypass_A = seq_item.bypass_A;
            alsu_vif.bypass_B = seq_item.bypass_B;
            alsu_vif.direction = direction_e'(seq_item.direction);
            alsu_vif.serial_in = seq_item.serial_in;
            @(negedge alsu_vif.clk);
            seq_item_port.item_done();
            `uvm_info("RUN_PHASE", seq_item.convert2string_stimulus(), UVM_HIGH)
        end
    endtask
endclass: alsu_driver

endpackage: alsu_driver_pkg
