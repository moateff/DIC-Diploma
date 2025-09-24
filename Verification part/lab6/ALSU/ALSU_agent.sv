package alsu_agent_pkg;
import uvm_pkg::*;
import alsu_sequencer_pkg::*;
import alsu_seq_item_pkg::*;
import alsu_driver_pkg::*;
import alsu_monitor_pkg::*;
import alsu_config_pkg::*;
`include "uvm_macros.svh"

class alsu_agent extends uvm_agent;
    `uvm_component_utils(alsu_agent)

    alsu_sequencer sequencer;
    alsu_driver driver;
    alsu_monitor monitor;
    alsu_config alsu_cfg;
    uvm_analysis_port #(alsu_seq_item) analysis_port;

    function new(string name = "alsu_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(alsu_config)::get(this, "", "CFG", alsu_cfg)) begin
            `uvm_fatal("BUILD_PHASE", "Agent - Unable to get the configuration abject")
        end

        sequencer = alsu_sequencer::type_id::create("sequencer", this);
        driver = alsu_driver::type_id::create("driver", this);
        monitor = alsu_monitor::type_id::create("monitor", this);

        analysis_port = new("analysis_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.alsu_vif = alsu_cfg.alsu_vif;
        monitor.alsu_vif = alsu_cfg.alsu_vif;

        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.analysis_port.connect(analysis_port);
    endfunction
endclass: alsu_agent

endpackage: alsu_agent_pkg