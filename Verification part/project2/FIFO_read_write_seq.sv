package fifo_read_write_seq_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
import fifo_shared_pkg::*;
`include "uvm_macros.svh"

class fifo_read_write_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_read_write_seq)

    fifo_seq_item seq_item;

    function new(string name = "fifo_read_write_seq");
        super.new(name);
    endfunction

    task body();
        repeat (NUM_TEST_CASES) begin
            seq_item = fifo_seq_item::type_id::create("seq_item");
            seq_item.set_dist(.rd_dist(50), .wr_dist(50));
            start_item(seq_item);
            assert (seq_item.randomize());
            finish_item(seq_item);
        end
    endtask
endclass : fifo_read_write_seq

endpackage : fifo_read_write_seq_pkg