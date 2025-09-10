package counter_pkg;

  // Parameter for data width
  parameter int WIDTH = 4;

  // Class to generate constrained stimulus for counter
  class counter_txn;

    // Signals (inputs to DUT)
    rand bit rst_n;
    rand bit load_n;
    rand bit ce;
    rand bit up_down;
    rand bit [WIDTH - 1:0] data_load;
    
    constraint c_rst_n {
        rst_n dist {0 := 5, 1 := 95}; // 5% active (0), 95% inactive (1)
    }

    constraint c_load_n {
        load_n dist {0 := 70, 1 := 30}; // 70% active (0), 30% inactive (1)
    }

    constraint c_ce {
        ce dist {0 := 30, 1 := 70}; // 30% active (0), 70% inactive (1)
    }

    constraint c_up_down {
      up_down dist {0 := 50, 1 := 50}; // 50% active (0), 50% inactive (1)
    }

    function void reset (rst_n = 1, load_n = 1, ce = 0, up_down = 0, data_load = 0);
        this.rst_n    = rst_n;
        this.load_n   = load_n;
        this.ce       = ce;
        this.up_down  = up_down;
        this.data_load = data_load;
    endfunction

  endclass : counter_txn

endpackage : counter_pkg
