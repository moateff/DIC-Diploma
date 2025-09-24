package alsu_test_pkg;
import uvm_pkg::*;
import alsu_env_pkg::*;
import alsu_config_pkg::*;
import alsu_reset_seq_pkg::*;
import alsu_main_seq_pkg::*;
`include "uvm_macros.svh"

class alsu_test extends uvm_test;
    `uvm_component_utils(alsu_test)

    alsu_env env;
    alsu_config alsu_cfg;
    alsu_reset_seq reset_seq;
    alsu_main_seq main_seq;

    function new(string name = "alsu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = alsu_env::type_id::create("env", this);
        alsu_cfg = alsu_config::type_id::create("alsu_cfg");
        reset_seq =  alsu_reset_seq::type_id::create("reset_seq");
        main_seq =  alsu_main_seq::type_id::create("main_seq");

        if (!uvm_config_db #(virtual alsu_if)::get(this, "", "ALSU_VIF", alsu_cfg.alsu_vif)) begin
            `uvm_fatal("BUILD_PHASE", "Test - Unable to get virtual interface of the ALSU")
        end

        uvm_config_db #(alsu_config)::set(this, "*", "CFG", alsu_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        // reset sequence 
        reset_seq.start(env.agent.sequencer);
        `uvm_info("RUN_PHASE", "Reset Asserted", UVM_LOW)
        `uvm_info("RUN_PHASE", "Reset Deasserted", UVM_LOW)

        // main sequence
        `uvm_info("RUN_PHASE", "Stimulus Generation Started", UVM_LOW)
        main_seq.start(env.agent.sequencer);
        `uvm_info("RUN_PHASE", "Stimulus Generation Ended", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
endclass: alsu_test

endpackage: alsu_test_pkg
