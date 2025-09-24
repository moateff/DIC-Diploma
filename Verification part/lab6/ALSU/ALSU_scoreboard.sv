package alsu_scoreboard_pkg;
import uvm_pkg::*;
import alsu_seq_item_pkg::*;
import alsu_shared_pkg::*;
`include "uvm_macros.svh"

class alsu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alsu_scoreboard)

    uvm_analysis_export #(alsu_seq_item) analysis_export;
    uvm_tlm_analysis_fifo #(alsu_seq_item) analysis_fifo;
    alsu_seq_item seq_item;
    
    logic cin_reg;
    logic red_op_A_reg;
    logic red_op_B_reg;
    logic bypass_A_reg;
    logic bypass_B_reg;
    direction_e direction_reg;
    logic serial_in_reg;
    opcode_e opcode_reg;
    logic signed [2:0] A_reg;
    logic signed [2:0] B_reg;
    logic [15:0] leds_ref;
    logic signed [5:0] out_ref;

    int error_count = 0;
    int correct_count = 0;

    function new(string name = "alsu_scoreboard", uvm_component parent = null);
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
            seq_item = alsu_seq_item::type_id::create("seq_item");
            analysis_fifo.get(seq_item);
            ref_model(seq_item);
            check_result(seq_item);
        end
    endtask

    task check_result(alsu_seq_item seq_item);
        if ((out_ref !== seq_item.out) || (leds_ref !== seq_item.leds)) begin
            `uvm_error("RUN_PHASE", $sformatf("Comparsion failed, Transaction received from DUT: %s While the reference out = 0b%0b, leds = 0x%0h ", seq_item.convert2string(), out_ref, leds_ref));
            error_count++;
        end else begin
            `uvm_info("RUN_PHASE", $sformatf("Comparsion successed, Transaction received from DUT: %s ", seq_item.convert2string()), UVM_HIGH);
            correct_count++;
        end
    endtask

    task ref_model(alsu_seq_item seq_item);    
        logic invalid_red_op, invalid_opcode, invalid;

        invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
        invalid_opcode = opcode_reg[1] & opcode_reg[2];
        invalid        = invalid_red_op | invalid_opcode;

        if (seq_item.rst) begin
            leds_ref = 16'h0;
        end else begin
            if (invalid) begin
                leds_ref = ~leds_ref;
            end else begin
                leds_ref = 16'h0;
            end
        end

        if (seq_item.rst) begin
            out_ref = 0;
        end else begin
            if (bypass_A_reg && bypass_B_reg) begin
                out_ref = (INPUT_PRIORITY == "A") ? A_reg : B_reg;
            end else if (bypass_A_reg) begin
                out_ref = A_reg;
            end else if (bypass_B_reg) begin
                out_ref = B_reg;
            end else if (invalid) begin
                out_ref = 0;
            end else begin
                case (opcode_reg)
                    OR: begin
                        if (red_op_A_reg && red_op_B_reg) begin
                            out_ref = (INPUT_PRIORITY == "A") ? (|A_reg) : (|B_reg);
                        end else if (red_op_A_reg) begin
                            out_ref = |A_reg;
                        end else if (red_op_B_reg) begin
                            out_ref = |B_reg;
                        end else begin
                            out_ref = A_reg | B_reg;
                        end
                    end
                    XOR: begin
                        if (red_op_A_reg && red_op_B_reg) begin
                            out_ref = (INPUT_PRIORITY == "A") ? (^A_reg) : (^B_reg);
                        end else if (red_op_A_reg) begin
                            out_ref = ^A_reg;
                        end else if (red_op_B_reg) begin
                            out_ref = ^B_reg;
                        end else begin
                            out_ref = A_reg ^ B_reg;
                        end
                    end
                    ADD: begin
                        if (FULL_ADDER == "ON") begin 
                            out_ref = A_reg + B_reg + cin_reg;
                        end else begin
                            out_ref = A_reg + B_reg;
                        end
                    end
                    MULT: out_ref = A_reg * B_reg;
                    SHIFT: begin
                        if (direction_reg) begin
                            out_ref = {out_ref[4:0], serial_in_reg};
                        end else begin
                            out_ref = {serial_in_reg, out_ref[5:1]};
                        end
                    end
                    ROTATE: begin
                        if (direction_reg) begin
                            out_ref = {out_ref[4:0], out_ref[5]};
                        end else begin
                            out_ref = {out_ref[0], out_ref[5:1]};
                        end
                    end
                    default: out_ref = out_ref;
                endcase
            end
        end

        if (seq_item.rst) begin
            cin_reg = 0;
            red_op_A_reg = 0;
            red_op_B_reg = 0;
            bypass_A_reg = 0;
            bypass_B_reg = 0;
            direction_reg = direction_e'(0);
            serial_in_reg = 0;
            opcode_reg = opcode_e'(0);
            A_reg = 0;
            B_reg = 0;
        end else begin
            cin_reg = seq_item.cin;
            red_op_A_reg = seq_item.red_op_A;
            red_op_B_reg = seq_item.red_op_B;
            bypass_A_reg = seq_item.bypass_A;
            bypass_B_reg = seq_item.bypass_B;
            direction_reg = seq_item.direction;
            serial_in_reg = seq_item.serial_in;
            opcode_reg = seq_item.opcode;
            A_reg = seq_item.A;
            B_reg = seq_item.B;
        end
    endtask
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("REPORT_PHASE", $sformatf("Total successful transactions: %0d ", correct_count), UVM_MEDIUM);
        `uvm_info("REPORT_PHASE", $sformatf("Total failed transactions: %0d ", error_count), UVM_MEDIUM);
    endfunction

endclass: alsu_scoreboard

endpackage: alsu_scoreboard_pkg
