package alsu_env_pkg;
import uvm_pkg::*;
import alsu_agent_pkg::*;
import alsu_scoreboard_pkg::*;
import alsu_coverage_pkg::*;
`include "uvm_macros.svh"

class alsu_env extends uvm_env;
    `uvm_component_utils(alsu_env)

    alsu_agent agent;
    alsu_scoreboard scoreboard;
    alsu_coverage coverage;

    function new(string name = "alsu_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = alsu_agent::type_id::create("agent", this);
        scoreboard = alsu_scoreboard::type_id::create("scoreboard", this);
        coverage = alsu_coverage::type_id::create("coverage", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agent.analysis_port.connect(scoreboard.analysis_export);
        agent.analysis_port.connect(coverage.analysis_export);
    endfunction
endclass: alsu_env

endpackage: alsu_env_pkg