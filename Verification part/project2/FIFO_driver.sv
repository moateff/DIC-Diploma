package fifo_driver_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"

class fifo_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(fifo_driver)

    virtual fifo_if fifo_vif;
    fifo_seq_item seq_item;

    function new(string name = "fifo_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = fifo_seq_item::type_id::create("seq_item");
            seq_item_port.get_next_item(seq_item);
            fifo_vif.rst_n = seq_item.rst_n;
            fifo_vif.wr_en = seq_item.wr_en;
            fifo_vif.rd_en = seq_item.rd_en;
            fifo_vif.data_in = seq_item.data_in;   
            @(negedge fifo_vif.clk);
            seq_item_port.item_done();
            `uvm_info("RUN_PHASE", seq_item.convert2string_stimulus(), UVM_HIGH)
        end
    endtask
endclass : fifo_driver

endpackage : fifo_driver_pkg
