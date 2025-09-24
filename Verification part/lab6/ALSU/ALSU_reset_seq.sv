package alsu_reset_seq_pkg;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
import alsu_shared_pkg::*;
`include "uvm_macros.svh"

class alsu_reset_seq extends uvm_sequence #(alsu_seq_item);
    `uvm_object_utils(alsu_reset_seq)
    
    alsu_seq_item seq_item;

    function new(string name = "alsu_reset_seq");
        super.new(name);
    endfunction

    task body();
        seq_item = alsu_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst = 1;
        seq_item.A = 0;
        seq_item.B = 0;
        seq_item.opcode = opcode_e'(0);
        seq_item.cin = 0;
        seq_item.red_op_A = 0;
        seq_item.red_op_B = 0;
        seq_item.bypass_A = 0;
        seq_item.bypass_B = 0;
        seq_item.direction = direction_e'(0);
        seq_item.serial_in = 0;
        finish_item(seq_item);
    endtask
endclass: alsu_reset_seq

endpackage: alsu_reset_seq_pkg