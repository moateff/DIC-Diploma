package fifo_test_pkg;
import uvm_pkg::*;
import fifo_env_pkg::*;
import fifo_config_obj_pkg::*;
import fifo_reset_seq_pkg::*;
import fifo_write_seq_pkg::*;
import fifo_read_seq_pkg::*;
import fifo_read_write_seq_pkg::*;
`include "uvm_macros.svh"

class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env env;
    fifo_config_obj fifo_cfg;
    fifo_reset_seq reset_seq;
    fifo_write_seq write_seq;
    fifo_read_seq read_seq;
    fifo_read_write_seq read_write_seq;

    function new(string name = "fifo_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = fifo_env::type_id::create("env", this);
        fifo_cfg = fifo_config_obj::type_id::create("fifo_cfg");
        reset_seq =  fifo_reset_seq::type_id::create("reset_seq");
        write_seq =  fifo_write_seq::type_id::create("write_seq");
        read_seq =  fifo_read_seq::type_id::create("read_seq");
        read_write_seq =  fifo_read_write_seq::type_id::create("read_write_seq");

        if (!uvm_config_db #(virtual fifo_if)::get(this, "", "FIFO_VIF", fifo_cfg.fifo_vif)) begin
            `uvm_fatal("BUILD_PHASE", "Test - Unable to get virtual interface of the fifo")
        end

        uvm_config_db #(fifo_config_obj)::set(this, "*", "CFG", fifo_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        // reset sequence 
        `uvm_info("RUN_PHASE", "Reset Asserted", UVM_LOW)
        reset_seq.start(env.agent.sequencer);
        `uvm_info("RUN_PHASE", "Reset Deasserted", UVM_LOW)

        // write only sequence
        `uvm_info("RUN_PHASE", "Write Only Sequence Started", UVM_LOW)
        write_seq.start(env.agent.sequencer);
        `uvm_info("RUN_PHASE", "Write Only Sequence Ended", UVM_LOW)
        
        // read only sequence
        `uvm_info("RUN_PHASE", "Read Only Sequence Started", UVM_LOW)
        read_seq.start(env.agent.sequencer);
        `uvm_info("RUN_PHASE", "Read Only Sequence Ended", UVM_LOW)

        // read/write sequence
        `uvm_info("RUN_PHASE", "Read/Write Sequence Started", UVM_LOW)
        read_write_seq.start(env.agent.sequencer);
        `uvm_info("RUN_PHASE", "Read/Write Sequence Ended", UVM_LOW)

        phase.drop_objection(this);
    endtask
endclass : fifo_test

endpackage : fifo_test_pkg
