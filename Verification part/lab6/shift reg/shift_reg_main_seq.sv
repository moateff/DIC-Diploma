package shift_reg_main_seq_pkg;
import uvm_pkg::*;
import shift_reg_seq_item_pkg::*;
`include "uvm_macros.svh"

class shift_reg_main_seq extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(shift_reg_main_seq)

    shift_reg_seq_item seq_item;

    function new(string name = "shift_reg_main_seq");
        super.new(name);
    endfunction

    task body;
        seq_item = shift_reg_seq_item::type_id::create("seq_item");
        repeat(100) begin
            start_item(seq_item);
            assert(seq_item.randomize(serial_in, direction, mode, datain));
            finish_item(seq_item);
        end
    endtask
endclass: shift_reg_main_seq
endpackage: shift_reg_main_seq_pkg