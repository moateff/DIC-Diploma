package ram_pkg;

    class ram_transaction;

        bit clk;
        rand bit write;
        rand bit read;
        rand bit [7:0] data_in;
        rand bit [15:0] address;
        bit [8:0] data_out;

    endclass

endpackage