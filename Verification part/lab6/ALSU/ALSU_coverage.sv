package alsu_coverage_pkg;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
import alsu_shared_pkg::*;
`include "uvm_macros.svh"

class alsu_coverage extends uvm_component;
    `uvm_component_utils(alsu_coverage)

    uvm_analysis_export #(alsu_seq_item) analysis_export;
    uvm_tlm_analysis_fifo #(alsu_seq_item) analysis_fifo;
    alsu_seq_item seq_item;

    covergroup cvg;
        ADD_MULT_A_cp: coverpoint seq_item.A{
            bins A_data_0 = {0};
            bins A_data_max = {MAXPOS};
            bins A_data_min = {MAXNEG};
            bins A_data_default = default;
        }

        RED_A_cp: coverpoint seq_item.A iff (seq_item.red_op_A){
            bins A_data_walkingones[] = {3'sb001,3'sb010,3'sb100};
        }

        ADD_MULT_B_cp: coverpoint seq_item.B{
            bins B_data_0 = {0};
            bins B_data_max = {MAXPOS};
            bins B_data_min = {MAXNEG};
            bins B_data_default = default;
        }

        RED_B_cp: coverpoint seq_item.B iff (seq_item.red_op_B && (!seq_item.red_op_A)){
            bins B_data_walkingones[] = {3'sb001,3'sb010,3'sb100};
        }

        opcode_cp: coverpoint seq_item.opcode{
            bins bins_shift[] = {SHIFT, ROTATE};
            bins bins_arith[] = {ADD, MULT};
            bins bins_bitwise[] = {OR, XOR};
            illegal_bins bins_invalid = {INVALID_6, INVALID_7};
        }

        opcode_shift_cp: coverpoint seq_item.opcode{
            option.weight = 0;
            bins bins_shift[] = {SHIFT, ROTATE};
        }

        opcode_arith_cp: coverpoint seq_item.opcode{
            option.weight = 0;
            bins bins_arith[] = {ADD, MULT};
        }

        opcode_bitwise_cp: coverpoint seq_item.opcode{
            option.weight = 0;
            bins bins_arith[] = {OR, XOR};
        }

        opcode_not_bitwise_cp: coverpoint seq_item.opcode{
            option.weight = 0;
            bins bins_not_bitwise[] = {[ADD:$]};
        }

        cin_cp: coverpoint seq_item.cin{
            option.weight = 0;
        }

        direction_cp: coverpoint seq_item.direction{
            option.weight = 0;
        }

        serial_in_cp: coverpoint seq_item.serial_in{
            option.weight = 0;
        }

        red_op_A_cp: coverpoint seq_item.red_op_A{
            option.weight = 0;
        }

        red_op_B_cp: coverpoint seq_item.red_op_B{
            option.weight = 0;
        }

        ADD_MULT_cross: cross ADD_MULT_A_cp, ADD_MULT_B_cp, opcode_arith_cp;
        
        ADD_cin_cross: cross cin_cp, opcode_arith_cp{
            ignore_bins bins_MULT = binsof(opcode_arith_cp) intersect {MULT};
        }
        
        SHIFT_direction_cross: cross direction_cp, opcode_shift_cp{
            ignore_bins bins_ROTATE = binsof(opcode_shift_cp) intersect {ROTATE};
        } 

        SHIFT_serial_in_cross: cross serial_in_cp, opcode_shift_cp{
            ignore_bins bins_ROTATE = binsof(opcode_shift_cp) intersect {ROTATE};
        } 
        
        red_op_A_cross: cross RED_A_cp, ADD_MULT_B_cp, opcode_bitwise_cp iff (seq_item.red_op_A){
            ignore_bins B_data_max = binsof(ADD_MULT_B_cp.B_data_max);
            ignore_bins B_data_min = binsof(ADD_MULT_B_cp.B_data_min);
        }

        red_op_B_cross: cross RED_B_cp, ADD_MULT_A_cp, opcode_bitwise_cp iff (seq_item.red_op_B && (!seq_item.red_op_A)){
            ignore_bins A_data_max = binsof(ADD_MULT_A_cp.A_data_max);
            ignore_bins A_data_min = binsof(ADD_MULT_A_cp.A_data_min);
        }

        invalid_red_op_A_cross: cross red_op_A_cp, opcode_not_bitwise_cp{
            ignore_bins red_op_A_0 = binsof(red_op_A_cp) intersect {0};
            illegal_bins red_op_A_1 = binsof(red_op_A_cp) intersect {1};
        }

        invalid_red_op_B_cross: cross red_op_B_cp, opcode_not_bitwise_cp{
            ignore_bins red_op_B_0 = binsof(red_op_B_cp) intersect {0};
            illegal_bins red_op_B_1 = binsof(red_op_B_cp) intersect {1};
        }
    endgroup

    function new(string name = "alsu_coverage", uvm_component parent = null);
        super.new(name, parent);
        cvg = new();
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
            sample_cvg(seq_item);
        end
    endtask

    task sample_cvg(alsu_seq_item seq_item);
        if((!seq_item.rst) || (!seq_item.bypass_A) || (!seq_item.bypass_B)) begin
            cvg.sample();
        end
    endtask
endclass: alsu_coverage

endpackage: alsu_coverage_pkg