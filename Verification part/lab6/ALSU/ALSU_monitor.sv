package alsu_monitor_pkg;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
import alsu_shared_pkg::*;
`include "uvm_macros.svh"

class alsu_monitor extends uvm_monitor;
    `uvm_component_utils(alsu_monitor)

    virtual alsu_if alsu_vif;
    alsu_seq_item seq_item;
    uvm_analysis_port #(alsu_seq_item) analysis_port;

    function new(string name = "alsu_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_port = new("analysis_port", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = alsu_seq_item::type_id::create("seq_item");
            @(negedge alsu_vif.clk);
            seq_item.rst = alsu_vif.rst;
            seq_item.A = alsu_vif.A;
            seq_item.B = alsu_vif.B;
            seq_item.opcode = opcode_e'(alsu_vif.opcode);
            seq_item.cin = alsu_vif.cin;
            seq_item.red_op_A = alsu_vif.red_op_A;
            seq_item.red_op_B = alsu_vif.red_op_B;
            seq_item.bypass_A = alsu_vif.bypass_A;
            seq_item.bypass_B = alsu_vif.bypass_B;
            seq_item.direction = direction_e'(alsu_vif.direction);
            seq_item.serial_in = alsu_vif.serial_in;
            seq_item.out = alsu_vif.out;
            seq_item.leds = alsu_vif.leds;
            
            analysis_port.write(seq_item);
            `uvm_info("RUN_PHASE", seq_item.convert2string(), UVM_HIGH)
        end
    endtask
endclass: alsu_monitor

endpackage: alsu_monitor_pkg
