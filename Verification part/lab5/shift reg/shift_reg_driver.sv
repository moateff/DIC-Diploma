package shift_reg_driver_pkg;
import uvm_pkg::*;
import shift_reg_config_pkg::*;
import shift_reg_seq_item_pkg::*;
`include "uvm_macros.svh"

class shift_reg_driver extends uvm_driver #(shift_reg_seq_item);
    `uvm_component_utils(shift_reg_driver)

    virtual shift_reg_if shift_reg_vif;
    shift_reg_config config_obj;

    shift_reg_seq_item seq_item;

    function new(string name = "shift_reg_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(shift_reg_config)::get(this, "", "CFG", config_obj)) begin
            `uvm_fatal("NO_CFG", "CFG object not found in config DB")
        end
    endfunction 

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        shift_reg_vif = config_obj.shift_reg_vif;
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            seq_item = shift_reg_seq_item::type_id::create("seq_item");
            seq_item_port.get_next_item(seq_item);

            shift_reg_vif.reset = seq_item.reset;
            shift_reg_vif.serial_in = seq_item.serial_in;
            shift_reg_vif.direction = seq_item.direction;
            shift_reg_vif.mode = seq_item.mode;
            shift_reg_vif.datain = seq_item.datain;
            @(negedge shift_reg_vif.clk);
            
            seq_item_port.item_done();
            `uvm_info("run_phase", seq_item.convert2string_stimulus(), UVM_LOW)
        end
    endtask
endclass: shift_reg_driver
endpackage: shift_reg_driver_pkg
