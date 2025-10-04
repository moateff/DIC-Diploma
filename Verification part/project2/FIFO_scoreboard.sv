package fifo_scoreboard_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
import fifo_shared_pkg::*;
`include "uvm_macros.svh"

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_export #(fifo_seq_item) analysis_export;
    uvm_tlm_analysis_fifo #(fifo_seq_item) analysis_fifo;
    fifo_seq_item seq_item;
    
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref;
    logic full_ref;
    logic empty_ref; 
    logic almostfull_ref; 
    logic almostempty_ref; 
    logic overflow_ref;
    logic underflow_ref;

    bit [FIFO_WIDTH-1:0] fifo_ref [$]; 

    function new(string name = "fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
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
            seq_item = fifo_seq_item::type_id::create("seq_item");
            analysis_fifo.get(seq_item);
            ref_model(seq_item);
            check_result(seq_item);
        end
    endtask

    task check_result(fifo_seq_item seq_item);
        if ((data_out_ref !== seq_item.data_out) || 
            (wr_ack_ref !== seq_item.wr_ack) || 
            (full_ref !== seq_item.full) || 
            (empty_ref !== seq_item.empty) || 
            (almostfull_ref !== seq_item.almostfull) || 
            (almostempty_ref !== seq_item.almostempty) ||
            (overflow_ref !== seq_item.overflow) || 
            (underflow_ref !== seq_item.underflow)) begin

            `uvm_error("RUN_PHASE", $sformatf("Comparsion failed, Transaction received from DUT: %s While the reference data_out_ref = 0x%0h, wr_ack_ref = %0b, full_ref = %0b, empty_ref = %0b, almostfull_ref = %0b, almostempty_ref = %0b, overflow_ref = %0b, underflow_ref = %0b ", seq_item.convert2string(), data_out_ref, wr_ack_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, overflow_ref, underflow_ref));
            error_count++;
        end else begin
            `uvm_info("RUN_PHASE", $sformatf("Comparsion successed, Transaction received from DUT: %s ", seq_item.convert2string()), UVM_HIGH);
            correct_count++;
        end
    endtask

    function void ref_model(fifo_seq_item seq_item);
        if (!seq_item.rst_n) begin
            fifo_ref.delete();

            wr_ack_ref = 0;
            overflow_ref = 0;
            underflow_ref = 0;
        end else begin
            if (seq_item.rd_en) begin
                if (!empty_ref) begin
                    data_out_ref = fifo_ref.pop_front();
                end else begin
                    underflow_ref = 1;
                end
            end else begin
                underflow_ref = 0;
            end

            if (seq_item.wr_en) begin
                if (!full_ref) begin
                    fifo_ref.push_back(seq_item.data_in);
                    wr_ack_ref = 1;
                end else begin
                    wr_ack_ref = 0;
                    overflow_ref = 1;
                end
            end else begin
                wr_ack_ref = 0;
                overflow_ref = 0;
            end
        end

        full_ref = (fifo_ref.size() == FIFO_DEPTH);
        empty_ref = (fifo_ref.size() == 0);
        almostfull_ref = (fifo_ref.size() == FIFO_DEPTH - 1);
        almostempty_ref = (fifo_ref.size() == 1);
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("REPORT_PHASE", $sformatf("Total successful transactions: %0d ", correct_count), UVM_MEDIUM);
        `uvm_info("REPORT_PHASE", $sformatf("Total failed transactions: %0d ", error_count), UVM_MEDIUM);
    endfunction

endclass : fifo_scoreboard

endpackage : fifo_scoreboard_pkg
