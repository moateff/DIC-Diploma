package fifo_coverage_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
import fifo_shared_pkg::*;
`include "uvm_macros.svh"

class fifo_coverage extends uvm_component;
    `uvm_component_utils(fifo_coverage)

    uvm_analysis_export #(fifo_seq_item) analysis_export;
    uvm_tlm_analysis_fifo #(fifo_seq_item) analysis_fifo;
    fifo_seq_item seq_item;

    covergroup cvr_grp;
        option.per_instance = 1;
        
        wr_en_cp: coverpoint seq_item.wr_en{
            bins wr_en_0 = {0};
            bins wr_en_1 = {1};
            option.weight = 0;
        }

        rd_en_cp: coverpoint seq_item.rd_en{
            bins rd_en_0 = {0};
            bins rd_en_1 = {1};
            option.weight = 0;
        }

        wr_ack_cp: coverpoint seq_item.wr_ack{
            bins wr_ack_0 = {0};
            bins wr_ack_1 = {1};
            option.weight = 0;
        }

        overflow_cp: coverpoint seq_item.overflow{
            bins overflow_0 = {0};
            bins overflow_1 = {1};
            option.weight = 0;
        }

        full_cp: coverpoint seq_item.full{
            bins full_0 = {0};
            bins full_1 = {1};
            option.weight = 0;
        }    

        empty_cp: coverpoint seq_item.empty{
            bins empty_0 = {0};
            bins empty_1 = {1};
            option.weight = 0;
        }

        almostfull_cp: coverpoint seq_item.almostfull{
            bins almostfull_0 = {0};
            bins almostfull_1 = {1};
            option.weight = 0;
        }

        almostempty_cp: coverpoint seq_item.almostempty{
            bins almostempty_0 = {0};
            bins almostempty_1 = {1};
            option.weight = 0;
        } 

        underflow_cp: coverpoint seq_item.underflow{
            bins underflow_0 = {0};
            bins underflow_1 = {1};
            option.weight = 0;
        }       

        wr_ack_cross: cross wr_en_cp, rd_en_cp, wr_ack_cp{
            illegal_bins wr_en_0 = binsof(wr_ack_cp) intersect {1} && binsof(wr_en_cp) intersect {0};
        }

        full_cross: cross wr_en_cp, rd_en_cp, full_cp{
            illegal_bins rd_en = binsof(full_cp) intersect {1} && binsof(rd_en_cp) intersect {1} ;
        }

        almostfull_cross: cross wr_en_cp, rd_en_cp, almostfull_cp;

        overflow_cross: cross wr_en_cp, rd_en_cp, overflow_cp{
            illegal_bins wr_en_0 = binsof(overflow_cp) intersect {1} && binsof(wr_en_cp) intersect {0};
        }

        empty_cross: cross wr_en_cp, rd_en_cp, empty_cp;

        almostempty_cross: cross wr_en_cp, rd_en_cp, almostempty_cp;

        underflow_cross: cross wr_en_cp, rd_en_cp, underflow_cp{
            illegal_bins rd_en_1 =binsof(underflow_cp) intersect {1} && binsof(rd_en_cp) intersect {0};
        }
    endgroup

    function new(string name = "fifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        cvr_grp = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        analysis_export = new("analysis_export", this);
        analysis_fifo = new("analysis_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        analysis_export.connect(analysis_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            analysis_fifo.get(seq_item);
            cvr_grp.sample();
        end
    endtask

endclass : fifo_coverage

endpackage : fifo_coverage_pkg