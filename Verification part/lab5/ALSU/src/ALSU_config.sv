package alsu_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_config_obj extends uvm_object;
    `uvm_object_utils(alsu_config_obj)

    virtual alsu_if alsu_config_vif;

    function new(string name = "alsu_config_obj");
        super.new(name);
    endfunction  
endclass: alsu_config_obj

endpackage: alsu_config_pkg
