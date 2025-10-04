package fifo_seq_item_pkg;
import uvm_pkg::*;
import fifo_shared_pkg::*;
`include "uvm_macros.svh"

class fifo_seq_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item)

    rand bit rst_n;
    rand bit wr_en;
    rand bit rd_en;
    rand bit [FIFO_WIDTH-1:0] data_in;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack;
    logic full;
    logic empty; 
    logic almostfull; 
    logic almostempty; 
    logic overflow;
    logic underflow;

    int RD_EN_ON_DIST, WR_EN_ON_DIST;

    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction

    function void set_dist(int rd_dist = 30, int wr_dist  = 70);
        this.RD_EN_ON_DIST = rd_dist;
        this.WR_EN_ON_DIST = wr_dist;
    endfunction

    function string convert2string();
        return $sformatf("%s rst_n = %0b, wr_en = %0b, rd_en = %0b, data_in = 0x%0h, data_out = 0x%0h, wr_ack = %0b, full = %0b, empty = %0b, almostfull = %0b, almostempty = %0b, overflow = %0b, underflow = %0b", 
            super.convert2string(), rst_n, wr_en, rd_en, data_in, data_out, wr_ack, full, empty, almostfull, almostempty, overflow, underflow);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("rst_n = %0b, wr_en = %0b, rd_en = %0b, data_in = 0x%0h",
                    rst_n, wr_en, rd_en, data_in);
    endfunction

    constraint c_rst_n {
        rst_n dist {1 := 95, 0 := 5};
    }
    
    constraint c_wr_en {
        wr_en dist {1 := WR_EN_ON_DIST, 0 := (100 - WR_EN_ON_DIST)};
    }
    
    constraint c_rd_en {
        rd_en dist {1 := RD_EN_ON_DIST, 0 := (100 - RD_EN_ON_DIST)};
    }
endclass : fifo_seq_item

endpackage : fifo_seq_item_pkg