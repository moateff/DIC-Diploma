package fifo_agent_pkg;
import uvm_pkg::*;
import fifo_sequencer_pkg::*;
import fifo_seq_item_pkg::*;
import fifo_driver_pkg::*;
import fifo_monitor_pkg::*;
import fifo_config_obj_pkg::*;
`include "uvm_macros.svh"

class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    fifo_sequencer sequencer;
    fifo_driver driver;
    fifo_monitor monitor;
    fifo_config_obj fifo_cfg;
    uvm_analysis_port #(fifo_seq_item) analysis_port;

    function new(string name = "fifo_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(fifo_config_obj)::get(this, "", "CFG", fifo_cfg)) begin
            `uvm_fatal("BUILD_PHASE", "Agent - Unable to get the configuration object")
        end

        sequencer = fifo_sequencer::type_id::create("sequencer", this);
        driver = fifo_driver::type_id::create("driver", this);
        monitor = fifo_monitor::type_id::create("monitor", this);

        analysis_port = new("analysis_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.fifo_vif = fifo_cfg.fifo_vif;
        monitor.fifo_vif = fifo_cfg.fifo_vif;

        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.analysis_port.connect(analysis_port);
    endfunction
endclass : fifo_agent

endpackage : fifo_agent_pkg